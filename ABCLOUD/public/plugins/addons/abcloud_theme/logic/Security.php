<?php
namespace addons\abcloud_theme\logic;

use think\Db;

class Security
{
    public static function csrfToken()
    {
        $adminId = function_exists('cmf_get_current_admin_id') ? (int) cmf_get_current_admin_id() : (int) session('ADMIN_ID');
        if ($adminId < 1) throw new \RuntimeException('管理员未登录');
        $secret = Db::name('abcloud_config')->where('key', '__csrf_secret')->value('value');
        if (!$secret) {
            $candidate = bin2hex(random_bytes(32));
            try {
                Db::name('abcloud_config')->insert(['key' => '__csrf_secret', 'value' => $candidate, 'updated_at' => date('Y-m-d H:i:s')]);
                $secret = $candidate;
            } catch (\Throwable $error) {
                $secret = Db::name('abcloud_config')->where('key', '__csrf_secret')->value('value');
                if (!$secret) throw $error;
            }
        }
        return hash_hmac('sha256', 'abcloud-theme:' . $adminId, (string) $secret);
    }
    public static function checkCsrf($request)
    {
        $token = (string) ($request->post('__csrf', $request->header('X-CSRF-TOKEN', '')));
        return $token !== '' && hash_equals(self::csrfToken(), $token);
    }
    public static function url($value, $allowEmpty = true)
    {
        $value = trim((string) $value);
        if ($value === '') return $allowEmpty ? '' : null;
        if (preg_match('/[\x00-\x1f\x7f]/', $value) || preg_match('/^javascript\s*:/i', $value) || preg_match('/^data\s*:/i', $value)) return null;
        if (strpos($value, '//') === 0) return null;
        if (preg_match('/^https?:\/\//i', $value)) return filter_var($value, FILTER_VALIDATE_URL) ? $value : null;
        if (preg_match('/^#[A-Za-z0-9_-]+$/', $value)) return $value;
        return preg_match('#^/[A-Za-z0-9_./?=&%+\x23:@~\-]*$#', $value) ? $value : null;
    }
    public static function html($value)
    {
        $value = (string) $value;
        if (class_exists('HTMLPurifier')) return (new \HTMLPurifier())->purify($value);
        $doc = new \DOMDocument('1.0', 'UTF-8');
        $previous = libxml_use_internal_errors(true);
        $doc->loadHTML('<?xml encoding="UTF-8"><div>' . $value . '</div>', LIBXML_HTML_NOIMPLIED | LIBXML_HTML_NODEFDTD);
        libxml_clear_errors();
        libxml_use_internal_errors($previous);
        $root = $doc->getElementsByTagName('div')->item(0);
        if (!$root) return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
        $allowed = ['p','br','strong','b','em','i','u','ul','ol','li','a','pre','code','blockquote','span'];
        $clean = function ($node) use (&$clean, $allowed) {
            foreach (iterator_to_array($node->childNodes) as $child) {
                if ($child->nodeType !== XML_ELEMENT_NODE) continue;
                $tag = strtolower($child->nodeName);
                if (!in_array($tag, $allowed, true)) {
                    while ($child->firstChild) $node->insertBefore($child->firstChild, $child);
                    $node->removeChild($child);
                    $clean($node);
                    continue;
                }
                foreach (iterator_to_array($child->attributes) as $attr) {
                    $name = strtolower($attr->name);
                    if ($tag === 'a' && $name === 'href' && self::url($attr->value) !== null) continue;
                    $child->removeAttributeNode($attr);
                }
                $clean($child);
            }
        };
        $clean($root);
        $result = '';
        foreach ($root->childNodes as $child) $result .= $doc->saveHTML($child);
        return $result;
    }
    public static function filename($name)
    {
        $name = basename(str_replace('\\', '/', (string) $name));
        $name = preg_replace('/[^\p{L}\p{N}._-]+/u', '_', $name);
        return mb_substr(trim($name, '._-') ?: 'file', 0, 120, 'UTF-8');
    }
    public static function safeExtension($name)
    {
        $ext = strtolower(pathinfo((string) $name, PATHINFO_EXTENSION));
        return in_array($ext, ['jpg','jpeg','png','gif','webp','mp4','webm'], true) ? $ext : null;
    }
}
