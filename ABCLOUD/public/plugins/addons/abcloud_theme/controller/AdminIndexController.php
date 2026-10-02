<?php
namespace addons\abcloud_theme\controller;

use addons\abcloud_theme\logic\Repository;
use addons\abcloud_theme\logic\Security;
use app\admin\controller\PluginAdminBaseController;
use think\Db;

class AdminIndexController extends PluginAdminBaseController
{
    const MODULES = ['carousel','feature','topnav','footernav','web_module','popup'];

    public function index()
    {
        if ($this->request->param('ajax')) return $this->api();
        $page = (string) $this->request->param('page', 'dashboard');
        if (!in_array($page, array_merge(self::MODULES, ['dashboard','config','operation_log','resources','carousel_global']), true)) $page = 'dashboard';
        $context = [
            'page' => $page,
            'items' => in_array($page, self::MODULES, true) ? Repository::list($page) : [],
            'item' => null,
            'configs' => Repository::configRows(),
            'configMap' => Repository::configMap(),
            'logs' => Db::name('abcloud_operation_log')->order('id desc')->limit(100)->select(),
            'logTotal' => (int) Db::name('abcloud_operation_log')->count(),
            'counts' => Repository::counts(),
            'adminName' => $this->adminName(),
            'csrfToken' => Security::csrfToken(),
            'pageUrl' => shd_addon_url('AbcloudTheme://AdminIndex/index'),
            'apiUrl' => shd_addon_url('AbcloudTheme://AdminIndex/index', ['ajax'=>1]),
            'assetUrl' => '/plugins/addons/abcloud_theme/assets',
            'publicUrl' => '/abcloud/content'
        ];
        return \addons\abcloud_theme\logic\AdminView::render($context);
    }

    public function api()
    {
        $module = (string) $this->request->param('module', 'carousel');
        $action = (string) $this->request->param('action', 'list');
        $mutating = !in_array($action, ['list','get','read','tree'], true);
        if ($mutating) {
            if (!$this->request->isPost()) return $this->respondError('仅支持 POST 修改', 405);
            if (!Security::checkCsrf($this->request)) return $this->respondError('CSRF 校验失败', 419);
        }
        try {
            if (in_array($module, self::MODULES, true)) return $this->contentApi($module, $action);
            if ($module === 'config' || $module === 'carousel_global') return $this->configApi($action);
            if ($module === 'operation_log') return $this->logApi($action);
            if ($module === 'resources') return $this->resourceApi($action);
            if ($module === 'upload') return $this->uploadApi($action);
            return $this->respondError('模块不支持', 404);
        } catch (\InvalidArgumentException $e) { return $this->respondError($e->getMessage(), 422); }
        catch (\Throwable $e) { return $this->respondError('操作失败', 500); }
    }

    private function contentApi($module, $action)
    {
        $id = (int) $this->request->post('id', $this->request->param('id', 0));
        if ($action === 'list' || $action === 'read') return $this->ok(['items'=>Repository::list($module)]);
        if ($action === 'get') return $this->ok(['item'=>Repository::item($module, $id)]);
        if ($action === 'delete' || $action === 'remove') {
            if ($id < 1) return $this->respondError('ID 无效', 422);
            $oldItem = Repository::item($module, $id);
            Db::startTrans();
            try { $count = Repository::delete($module, $id); $this->markManaged($module); $this->log('delete', $module, ['id'=>$id,'title'=>$oldItem['title']??'']); Db::commit(); return $this->ok(['deleted'=>(int)$count]); }
            catch (\Throwable $e) { Db::rollback(); throw $e; }
        }
        if ($action === 'sort') return $this->sortApi($module);
        if (!in_array($action, ['add','create','update','save'], true)) return $this->respondError('操作不支持', 400);
        $data = $this->payload($module);
        if ($module === 'topnav' && $id && (int)$data['parent_id'] === $id) return $this->respondError('不能把节点设为自身父级', 422);
        if ($module === 'topnav' && $id && in_array((int)$data['parent_id'], Repository::descendants($id), true)) return $this->respondError('不能把节点移动到自身子树', 422);
        if ($module === 'topnav' && $data['parent_id'] && !Repository::item('topnav', $data['parent_id'])) return $this->respondError('父级导航不存在', 422);
        if ($module === 'topnav' && $data['parent_id']) {
            $ancestor = (int)$data['parent_id'];
            for ($depth = 1; $ancestor; $depth++) {
                if ($depth > 2) return $this->respondError('导航最多支持三级', 422);
                $ancestor = (int)(Repository::item('topnav', $ancestor)['parent_id'] ?? 0);
            }
        }
        Db::startTrans();
        try { $saved = Repository::save($module, $data, $id); $this->markManaged($module); $this->log($id ? 'update' : 'add', $module, ['id'=>$saved,'title'=>$data['title']??'']); Db::commit(); return $this->ok(['id'=>$saved,'item'=>Repository::item($module,$saved)]); }
        catch (\Throwable $e) { Db::rollback(); throw $e; }
    }

    private function payload($module)
    {
        $r = $this->request;
        $fieldNames = [
            'title'=>'标题','description'=>'描述','media_url'=>'主图地址','desktop_image_url'=>'电脑端图片',
            'mobile_image_url'=>'手机端图片','poster_url'=>'视频封面','link_url'=>'链接地址','jump_url'=>'跳转地址',
            'label_text'=>'标签文字','label_badge'=>'标签徽标','button_text'=>'按钮文字','icon_url'=>'图标地址',
            'category'=>'分类','content'=>'内容','name'=>'名称','url'=>'地址','menu_desc'=>'菜单描述','recommended_tags'=>'推荐标签'
        ];
        $text = function($key, $max = 500) use ($r, $fieldNames) {
            $v = trim((string)$r->post($key, ''));
            if (strlen($v) > $max) {
                $label = $fieldNames[$key] ?? $key;
                throw new \InvalidArgumentException($label.' 超过长度限制');
            }
            return $v;
        };
        $url = function($key) use ($text, $fieldNames) {
            $v = $text($key);
            $safe = Security::url($v);
            if ($v !== '' && $safe === null) {
                $label = $fieldNames[$key] ?? $key;
                throw new \InvalidArgumentException($label.' URL 不安全');
            }
            return $safe;
        };
        $base = ['sort_order'=>max(0,(int)$r->post('sort_order',0)),'status'=>$r->post('status',1)?1:0];
        if ($module === 'carousel') { $data=$base + ['title'=>$text('title',255),'description'=>$text('description',4000),'media_type'=>in_array($r->post('media_type','image'),['image','video'],true)?$r->post('media_type'):'image','media_url'=>$url('media_url'),'mobile_image_url'=>$url('mobile_image_url'),'desktop_image_url'=>$url('desktop_image_url'),'poster_url'=>$url('poster_url'),'link_url'=>$url('link_url'),'label_text'=>$text('label_text',100),'label_badge'=>$text('label_badge',50),'button_text'=>$text('button_text',50),'time_limit'=>$r->post('time_limit',0)?1:0,'pc_theme'=>in_array($r->post('pc_theme','black'),['black','white'],true)?$r->post('pc_theme'):'black','mobile_theme'=>in_array($r->post('mobile_theme','black'),['black','white'],true)?$r->post('mobile_theme'):'black','text_visible'=>$r->post('text_visible',1)?1:0,'jump_type'=>$text('jump_type',16),'jump_url'=>$url('jump_url'),'new_tab'=>$r->post('new_tab',0)?1:0]; if($data['title']===''||($data['media_url']===''&&$data['mobile_image_url']===''&&$data['desktop_image_url']==='')) throw new \InvalidArgumentException('轮播标题和图片不能为空'); return $data; }
        if ($module === 'feature') { $data=$base + ['title'=>$text('title',100),'description'=>$text('description',255),'icon_url'=>$url('icon_url'),'link_url'=>$url('link_url')]; if($data['title']===''||$data['icon_url']===''||$data['link_url']==='') throw new \InvalidArgumentException('快捷入口标题、图标和链接不能为空'); return $data; }
        if ($module === 'topnav') { $parent=(int)$r->post('parent_id',0); if ($parent<0) throw new \InvalidArgumentException('父级无效'); $data=$base + ['title'=>$text('title',100),'link_url'=>$url('link_url'),'parent_id'=>$parent,'menu_type'=>$text('menu_type',20),'recommended_tags'=>$text('recommended_tags',200),'menu_desc'=>$text('menu_desc',500)]; if($data['title']==='') throw new \InvalidArgumentException('导航标题不能为空'); return $data; }
        if ($module === 'footernav') { $data=$base + ['category'=>$text('category',50),'title'=>$text('title',100),'description'=>$text('description',255),'link_url'=>$url('link_url'),'icon_url'=>$url('icon_url')]; if($data['category']===''||$data['title']==='') throw new \InvalidArgumentException('底部导航分类和标题不能为空'); return $data; }
        if ($module === 'web_module') { $data=$base + ['category'=>$text('category',50),'title'=>$text('title',200),'description'=>Security::html($text('description',10000)),'link_url'=>$url('link_url'),'icon_url'=>$url('icon_url'),'image_url'=>$url('image_url')]; if($data['category']===''||$data['title']==='') throw new \InvalidArgumentException('模块分类和标题不能为空'); return $data; }
        if ($module === 'popup') { $data=$base + ['title'=>$text('title',255),'content'=>Security::html($text('content',50000)),'link_url'=>$url('link_url'),'button_text'=>$text('button_text',50),'show_type'=>in_array($r->post('show_type','always'),['always','once'],true)?$r->post('show_type'):'always']; if($data['title']==='') throw new \InvalidArgumentException('弹窗标题不能为空'); return $data; }
        throw new \InvalidArgumentException('模块不支持');
    }

    private function sortApi($module)
    {
        $orders = $this->request->post('orders', []); if (is_string($orders)) $orders=json_decode($orders,true); if (!is_array($orders)||count($orders)>1000) return $this->respondError('排序数据无效',422);
        $parent = (int)$this->request->post('parent_id',0); $seq=1; Db::startTrans(); try { foreach ($orders as $id) { Db::name(Repository::table($module))->where('id',(int)$id)->where($module==='topnav'?'parent_id':'id',$module==='topnav'?$parent:(int)$id)->update(['sort_order'=>$seq++,'updated_at'=>date('Y-m-d H:i:s')]); } $this->log('sort',$module,['parent_id'=>$parent]); Db::commit(); return $this->ok(); } catch(\Throwable $e){Db::rollback();throw $e;}
    }

    private function configApi($action)
    {
        if (in_array($action,['list','read'],true)) return $this->ok(['configs'=>Repository::configRows(),'configMap'=>Repository::configMap()]);
        if (!in_array($action,['save','update','set'],true)) return $this->respondError('操作不支持',400);
        $values=$this->request->post('configs',null); if (!is_array($values)) $values=[$this->request->post('key','')=>$this->request->post('value','')];
        Db::startTrans(); try { foreach($values as $key=>$value){ if(!is_scalar($value)) throw new \InvalidArgumentException('配置值无效'); $key=(string)$key; if(!preg_match('/^[A-Za-z0-9_.-]{1,100}$/',$key) || strpos($key, '__')===0 || strpos($key, 'managed_')===0) throw new \InvalidArgumentException('配置键无效'); Db::name('abcloud_config')->where('key',$key)->find() ? Db::name('abcloud_config')->where('key',$key)->update(['value'=>(string)$value,'updated_at'=>date('Y-m-d H:i:s')]) : Db::name('abcloud_config')->insert(['key'=>$key,'value'=>(string)$value,'updated_at'=>date('Y-m-d H:i:s')]); } $this->log('update','config',['keys'=>array_keys($values)]); Db::commit(); return $this->ok(['configMap'=>Repository::configMap()]); } catch(\Throwable $e){Db::rollback();throw $e;}
    }

    private function logApi($action) { if($action!=='list') return $this->respondError('仅支持读取',405); return $this->ok(['items'=>Db::name('abcloud_operation_log')->order('id desc')->limit(200)->select(),'total'=>(int)Db::name('abcloud_operation_log')->count()]); }

    private function resourceApi($action)
    {
        if ($action==='tree' || $action==='list') return $this->ok(['items'=>Db::name('abcloud_resource')->order('parent_id asc,name asc')->select()]);
        $id=(int)$this->request->post('id',0); $name=Security::filename($this->request->post('name','')); $parent=(int)$this->request->post('parent_id',0);
        if(in_array($action,['mkdir','create_dir'],true)){ if($name==='file') return $this->respondError('目录名无效',422); if($parent && !Db::name('abcloud_resource')->where(['id'=>$parent,'kind'=>'dir'])->find()) return $this->respondError('父目录不存在',404); $path=$this->resourcePath($parent,$name); $new=Db::name('abcloud_resource')->insertGetId(['parent_id'=>$parent,'name'=>$name,'kind'=>'dir','path'=>$path,'created_at'=>date('Y-m-d H:i:s')]); $this->log('add','resources',['id'=>$new,'kind'=>'dir']); return $this->ok(['id'=>$new]); }
        if(in_array($action,['rename','update'],true)){
            if(!$id)return $this->respondError('ID 无效',422);
            $row=Db::name('abcloud_resource')->where('id',$id)->find();
            if(!$row)return $this->respondError('资源不存在',404);
            Db::startTrans();
            try {
                $change=['name'=>$name,'updated_at'=>date('Y-m-d H:i:s')];
                if($row['kind']==='dir'){
                    $oldPath=$row['path'];
                    $newPath=$this->resourcePath((int)$row['parent_id'],$name);
                    $change['path']=$newPath;
                    foreach(Db::name('abcloud_resource')->where('kind','dir')->where('path','like',$oldPath.'/%')->select() as $child){
                        Db::name('abcloud_resource')->where('id',$child['id'])->update(['path'=>$newPath.substr($child['path'],strlen($oldPath))]);
                    }
                }
                Db::name('abcloud_resource')->where('id',$id)->update($change);
                $this->log('update','resources',['id'=>$id]);
                Db::commit();
            } catch(\Throwable $error){Db::rollback();throw $error;}
            return $this->ok();
        }
        if(in_array($action,['delete','remove'],true)){
            if(!$id)return $this->respondError('ID 无效',422);
            $ids=array_merge([$id],$this->resourceDescendants($id));
            $resources=Db::name('abcloud_resource')->whereIn('id',$ids)->select();
            if (!count($resources)) return $this->respondError('资源不存在', 404);
            Db::startTrans();
            try {
                if (Repository::resourceReferences($resources)) {
                    Db::rollback();
                    return $this->respondError('资源仍被内容或配置引用，请先移除引用', 409);
                }
                Db::name('abcloud_resource')->whereIn('id',$ids)->delete();
                $this->log('delete','resources',['ids'=>$ids]);
                Db::commit();
            }
            catch(\Throwable $error){Db::rollback();throw $error;}
            foreach($resources as $row) if(($row['kind']??'')==='file') $this->removeResourceFile($row['path']??'');
            return $this->ok(['deleted'=>count($ids)]);
        }
        return $this->respondError('资源操作不支持',400);
    }

    private function uploadApi($action)
    {
        if(!in_array($action,['upload','remote_upload'],true)) return $this->respondError('上传操作不支持',400);
        $dir=dirname(__DIR__).'/assets/content'; if(!is_dir($dir)) mkdir($dir,0755,true); $source=null; $original=''; $mime='';
        if($action==='upload'){ $file=$this->request->file('file'); if(!$file)return $this->respondError('缺少文件',422); $original=$file->getInfo()['name']; $source=$file->getPathname(); $mime=(string)$file->getMimeType(); }
        else {
            $url = Security::url($this->request->post('url', ''), false);
            if (!$url || strncasecmp($url, 'https://', 8) !== 0) return $this->respondError('远程地址必须为 HTTPS', 422);
            $host = parse_url($url, PHP_URL_HOST);
            if (!$host || parse_url($url, PHP_URL_USER) || parse_url($url, PHP_URL_PASS) || (parse_url($url, PHP_URL_PORT) ?: 443) !== 443) return $this->respondError('远程地址不允许', 422);
            $records = dns_get_record($host, DNS_A | DNS_AAAA);
            $ip = null;
            foreach ($records ?: [] as $record) {
                $address = $record['ip'] ?? ($record['ipv6'] ?? '');
                if (!filter_var($address, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE)) return $this->respondError('远程地址不允许', 422);
                if (isset($record['ip']) && $ip === null) $ip = $address;
            }
            if ($ip === null) return $this->respondError('远程地址解析失败', 422);
            $source = tempnam(sys_get_temp_dir(), 'abcloud_');
            $handle = fopen($source, 'wb');
            $size = 0;
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RESOLVE => [$host . ':443:' . $ip], CURLOPT_PROXY => '', CURLOPT_FOLLOWLOCATION => false,
                CURLOPT_PROTOCOLS => CURLPROTO_HTTPS, CURLOPT_CONNECTTIMEOUT => 5,
                CURLOPT_TIMEOUT => 20, CURLOPT_SSL_VERIFYPEER => true, CURLOPT_SSL_VERIFYHOST => 2,
                CURLOPT_WRITEFUNCTION => function ($curl, $chunk) use ($handle, &$size) {
                    $length = strlen($chunk);
                    $size += $length;
                    return $size <= 20 * 1024 * 1024 ? fwrite($handle, $chunk) : 0;
                }
            ]);
            $success = curl_exec($ch);
            $status = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);
            fclose($handle);
            if (!$success || $status < 200 || $status >= 300 || !$size) { @unlink($source); return $this->respondError('远程资源获取失败', 422); }
            $original = basename(parse_url($url, PHP_URL_PATH));
        }
        $ext = Security::safeExtension($original);
        if (!$ext) { if ($action !== 'upload') @unlink($source); return $this->respondError('文件类型不允许', 422); }
        $size = filesize($source);
        if (!$size || $size > 20 * 1024 * 1024) { if ($action !== 'upload') @unlink($source); return $this->respondError('文件大小不允许', 422); }
        $detected = (new \finfo(FILEINFO_MIME_TYPE))->file($source);
        $allowed = ['jpg'=>'image/jpeg','jpeg'=>'image/jpeg','png'=>'image/png','gif'=>'image/gif','webp'=>'image/webp','mp4'=>'video/mp4','webm'=>'video/webm'];
        if ($detected !== $allowed[$ext]) { if ($action !== 'upload') @unlink($source); return $this->respondError('文件内容与类型不符', 422); }
        $name = Security::filename(pathinfo($original, PATHINFO_FILENAME)) . '_' . bin2hex(random_bytes(6)) . '.' . $ext;
        $target = $dir . '/' . $name;
        $parent = (int)$this->request->post('parent_id', 0);
        if ($parent && !Db::name('abcloud_resource')->where(['id'=>$parent,'kind'=>'dir'])->find()) { if ($action !== 'upload') @unlink($source); return $this->respondError('目标目录不存在', 422); }
        $moved = $action === 'upload' ? move_uploaded_file($source, $target) : rename($source, $target);
        if (!$moved) { if ($action !== 'upload') @unlink($source); return $this->respondError('保存文件失败', 500); }
        chmod($target, 0644);
        $url = '/plugins/addons/abcloud_theme/assets/content/' . $name;
        try {
            $id = Db::name('abcloud_resource')->insertGetId(['parent_id'=>$parent,'name'=>$name,'kind'=>'file','path'=>$url,'mime'=>$detected,'size'=>$size,'created_at'=>date('Y-m-d H:i:s')]);
        } catch (\Throwable $error) { @unlink($target); throw $error; }
        $this->log('add', 'upload', ['id'=>$id,'name'=>$name]);
        return $this->ok(['id'=>$id,'url'=>$url,'name'=>$name]);
    }

    private function resourcePath($parent,$name){ if(!$parent)return '/'.$name; $p=Db::name('abcloud_resource')->where('id',$parent)->value('path'); return rtrim((string)$p,'/').'/'.$name; }
    private function resourceDescendants($id,$depth=0){ if($depth>32)throw new \RuntimeException('目录层级过深'); $out=[]; foreach(Db::name('abcloud_resource')->where('parent_id',(int)$id)->column('id') as $child){$out[]=(int)$child;$out=array_merge($out,$this->resourceDescendants($child,$depth+1));} return $out; }
    private function removeResourceFile($path){ $base=realpath(dirname(__DIR__).'/assets/content'); if(!$base||strpos($path,'/plugins/addons/abcloud_theme/assets/content/')!==0)return; $file=realpath($base.'/'.basename($path)); if($file&&strpos($file,$base.DIRECTORY_SEPARATOR)===0&&is_file($file))@unlink($file); }
    private function markManaged($module){ Repository::setConfig('managed_'.$module, '1'); }
    private function adminName(){
        $adminId=function_exists('cmf_get_current_admin_id')?(int)cmf_get_current_admin_id():(int)session('ADMIN_ID');
        if($adminId>0){
            $admin=Db::name('user')->where('id',$adminId)->field('user_nickname,user_login')->find();
            if($admin)return (string)($admin['user_nickname']?:$admin['user_login']);
        }
        return '管理员';
    }
    private function humanizeLog($action, $module, $detail)
    {
        if (is_string($detail)) {
            $trimmed = trim($detail);
            if (($trimmed[0] ?? '') === '{' || ($trimmed[0] ?? '') === '[') {
                $decoded = json_decode($trimmed, true);
                if (is_array($decoded)) $detail = $decoded;
                else return $detail;
            } else {
                return $detail;
            }
        }
        if (!is_array($detail)) return (string)$detail;

        $modMap = [
            'carousel'=>'轮播图','feature'=>'快捷入口','topnav'=>'顶部导航','footernav'=>'底部导航',
            'web_module'=>'通用模块','popup'=>'弹窗通知','config'=>'网站配置','carousel_global'=>'轮播图全局设置',
            'resources'=>'资源库','upload'=>'资源上传','operation_log'=>'操作日志'
        ];
        $actMap = ['add'=>'新增','update'=>'修改','delete'=>'删除','sort'=>'排序'];
        $cfgMap = [
            'switch_effect'=>'切换特效','carousel_speed'=>'轮播播放间隔','carousel_height'=>'轮播图高度',
            'progress_height'=>'进度条高度','progress_bar'=>'进度条粗细','video_zoom'=>'视频放大尺寸',
            'error_image'=>'异常占位图','site_name'=>'网站名称','site_keywords'=>'网站关键词',
            'site_description'=>'网站描述','service_phone'=>'客服电话','service_email'=>'客服邮箱',
            'company_intro'=>'公司简介','official_website_logo'=>'官网标志图片'
        ];
        $modName = $modMap[$module] ?? $module;
        $actName = $actMap[$action] ?? $action;

        if (!empty($detail['keys']) && is_array($detail['keys'])) {
            $keys = array_values(array_filter($detail['keys'], static function($k){
                return strpos($k, '__') !== 0 && strpos($k, 'managed_') !== 0;
            }));
            $mapped = array_map(static function($k) use ($cfgMap) { return $cfgMap[$k] ?? $k; }, $keys);
            if (empty($mapped)) return '保存配置项';
            $isGlobal = true;
            foreach ($keys as $k) {
                if (!in_array($k, ['switch_effect','carousel_speed','carousel_height','progress_height','progress_bar','video_zoom','error_image'], true)) {
                    $isGlobal = false;
                    break;
                }
            }
            if ($isGlobal) return '保存轮播全局设置（' . implode('、', $mapped) . '）';
            $isSite = true;
            foreach ($keys as $k) {
                if (!in_array($k, ['site_name','site_keywords','site_description','service_phone','service_email','company_intro','official_website_logo'], true)) {
                    $isSite = false;
                    break;
                }
            }
            if ($isSite) return '保存网站基本配置（' . implode('、', $mapped) . '）';
            return '保存配置项（' . implode('、', $mapped) . '）';
        }

        if ($action === 'upload' || $module === 'upload' || (!empty($detail['name']) && $action === 'add' && empty($detail['kind']))) {
            return '上传文件：' . ($detail['name'] ?? ('编号 ' . ($detail['id'] ?? '')));
        }
        if (($detail['kind'] ?? '') === 'dir' && $action === 'add') {
            return '新建文件夹：' . ($detail['name'] ?? ('编号 ' . ($detail['id'] ?? '')));
        }
        if ($action === 'update' && $module === 'resources' && !empty($detail['name'])) {
            return '重命名资源为：' . $detail['name'] . (!empty($detail['id']) ? '（编号: ' . $detail['id'] . '）' : '');
        }
        if (!empty($detail['ids']) && is_array($detail['ids'])) {
            return '批量删除' . $modName . '（编号: ' . implode(', ', $detail['ids']) . '）';
        }
        if (isset($detail['id'])) {
            $title = !empty($detail['title']) ? '“' . $detail['title'] . '”' : '';
            if ($action === 'add') return '新增' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $detail['id'] . '）';
            if ($action === 'update') return '修改' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $detail['id'] . '）';
            if ($action === 'delete') return '删除' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $detail['id'] . '）';
            return $actName . $modName . '（编号: ' . $detail['id'] . '）';
        }
        if (isset($detail['parent_id'])) {
            if ((int)$detail['parent_id'] === 0) return '调整顶级导航显示顺序';
            return '调整子导航显示顺序（父级编号: ' . $detail['parent_id'] . '）';
        }
        return json_encode($detail, JSON_UNESCAPED_UNICODE);
    }
    private function log($action,$module,$detail=[]){
        $thisId=function_exists('cmf_get_current_admin_id')?(int)cmf_get_current_admin_id():(int)session('ADMIN_ID');
        $thisName=$this->adminName();
        $text=$this->humanizeLog($action,$module,$detail);
        Db::name('abcloud_operation_log')->insert([
            'admin_id'=>$thisId?:null,
            'admin_name'=>$thisName,
            'action'=>$action,
            'module'=>$module,
            'detail'=>$text,
            'ip'=>$this->request->ip(),
            'user_agent'=>substr((string)$this->request->header('user-agent',''),0,500),
            'created_at'=>date('Y-m-d H:i:s')
        ]);
    }
    private function ok($data=[]){ return json(['code'=>0,'msg'=>'ok','data'=>$data]); }
    private function respondError($msg,$status=422){ return json(['code'=>$status,'msg'=>$msg,'data'=>[]], $status); }
}
