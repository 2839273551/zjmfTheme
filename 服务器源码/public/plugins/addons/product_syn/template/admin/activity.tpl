
<section class="admin-main">
    <div class="container-fluid">
        <div class="page-container">
            <div class="card">
                <div class="card-body">
                    <!-- class="col-lg-1 col-md-12 col-sm-12" -->
                    <div class="card-title row">
                        <div class="pl-4 pr-4">{$Title}</div>
                        <div class="col-lg-8 col-md-12 col-sm-12">
                            {foreach $PluginsAdminMenu as $v}
                                {if $v['custom']}
                                    <span  class="ml-2"><a  class="h5" href="{$v.url}" target="_blank">{$v.name}</a></span>
                                {else/}
                                    <span  class="ml-2"> <a  class="h5" href="{$v.url}">{$v.name}</a></span>
                                {/if}
                            {/foreach}
                        </div>
                    </div>

                    <div class="tab-content mt-4">

                        <div class="table-tools">
                            <a href="javascript:;" class="btn btn-success w-sm nohide add-activity">
                                <i class="fas fa-plus-circle"></i> 添加活动
                            </a>

                            <div id="renewMsg" style="color: #ff0000;"></div>
                        </div>
                        <div class="table-body auto-login-content" style="margin-top: 10px;">
                            <table class="table table-bordered table-hover activity-table">
                                <thead class="thead-light">
                                <tr>

                                    <th class="center t1" data-name="id" data-type="text" data-readonly="readonly">ID </th>
                                    <th class="t4" data-name="title" data-type="text">活动名称</th>

                                    <th data-type="date" data-name="start_time">开始时间</th>
                                    <th data-type="date" data-name="end_time">结束时间</th>
                                    <th>说明<span style="display: none;"><a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=activityset&id=@{id}">活动设置</a></span></th>
                                    <th>奖品<span style="display: none;"><a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=index&id=@{id}">奖品设置</a></span></th>

                                    <th class="t4" data-name="status">状态<span style="display: none"><div class="custom-control custom-switch" dir="ltr">
                                                <input type="checkbox" data-switch class="custom-control-input" id="customSwitchsizemd@{id}" data-id="@{id}" name="status">
                                                <label class="custom-control-label" for="customSwitchsizemd@{id}"></label>
                                            </div></span></th>
                                    <th data-type="set" class="center t5">操作<span style="display: none;">
                                            <a href="javascript:;" class="btn btn-link get-md5 edit"><i class="fas fa-edit"></i> 编辑</a>
                                            <a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=winningrecord&activity_id=@{id}" class="btn btn-link get-md5"><i class="far fa-cog"></i> 获奖记录</a>
                                        </span></th>
                                </tr>
                                </thead>
                                <tbody>
                                {foreach $List as $key=>$item}
                                    <tr data-data='{$item|json_encode}'>
                                        <td class="center">{$item.id}</td>


                                        <td>{$item.title}</td>
                                        <td>{$item.start_time}</td>
                                        <td>{$item.end_time}</td>
                                        <td><a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=activityset&id={$item.id}">活动设置{empty name="item.setting"}，未设置{/empty}</a></td>
                                        <td><a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=index&id={$item.id}">奖品设置{empty name="item.setting"}，未设置{/empty}</a></td>
                                        <td>
                                            <div class="custom-control custom-switch" dir="ltr">
                                                <input type="checkbox" data-switch class="custom-control-input" id="customSwitchsizemd{$item.id}" data-id="{$item.id}" name="status"  {eq name="item.status" value="2"}checked{/eq}>
                                                <label class="custom-control-label" for="customSwitchsizemd{$item.id}"></label>
                                            </div>

                                        </td>
                                        <td>
                                            <a href="javascript:;" class="btn btn-link get-md5 edit"><i class="fas fa-edit"></i> 编辑</a>
                                            <a href="addons?_plugin={$GzhxPluginPath}&_controller=admin_index&_action=winningrecord&activity_id={$item.id}" class="btn btn-link get-md5"><i class="far fa-cog"></i> 获奖记录</a>

                                        </td>
                                    </tr>
                                {/foreach}
                                </tbody>
                            </table>
                        </div>

                        <div class="table-body">文档说明：<a href="https://html5code.org/type/zjmf.html" target="_blank">https://html5code.org/type/zjmf.html</a> </div>


                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<script>
    let ProductGroups={$Groups|json_encode};
    $(function () {
        let queryToJson=function (hash){
            let str=hash?window.location.hash:window.location.search
            if( !str ) return { };
            if(str) str=str.substr(1);
            if( !str ) return { };
            let arr = str.split('&');
            let data={ };
            $.each( arr, function (k,v) {

                if(v.indexOf("=")>-1){
                    let d=v.indexOf("=");
                    data[ decodeURIComponent(v.substr(0,d)) ]=decodeURIComponent(v.substr(d+1));

                }

            } );
            return data;
        }
        let jsonToQuery=function (json){
            return  Object.keys(json).map(function (key) {
                return json[key]? (key + "=" + encodeURIComponent(json[key])):"";
            }).join("&");
        }
        let ajax=function (option){
            $.ajax({
                    dataType: "json",
                    type: option.type||"post",

                    headers: {
                        "X-Requested-With": "XMLHttpRequest",

                    },
                    url: option.url||"",
                    data:option.data,
                    async:true,
                    success: function (t) {



                        if( t.status==1 ){
                            if(option.success)  option.success(t.info);
                        }else{
                            if(option.error){
                                option.error(t.info)
                            }else{
                                $('#renewMsg').html(t.info);
                            }
                        }
                    },

                    error: function (request, status, errorThrown) {
                        if(option.error){ option.error("网络错误，请重试") }else{
                            $('#renewMsg').html("网络错误，请重试");
                        }
                    }
                }
            );
        }

        $('.set-menu-name').off("click").on("click",function (){
            let val=$('input[name="v-menu-name"]').val();
            if(!val){
                $('input[name="v-menu-name"]').css({
                    borderColor:'#ff0000'
                });
                return false;
            }
            $('input[name="v-menu-name"]').css({
                borderColor:'#000000'
            });
            ajax({
                data:{
                    action:'setmenu',
                    name:val
                },success:function (res){
                    $('#renewMsg').html(res);
                }
            })
        })

        let _setTable=function (table,val){

            let setVal=function (dom,item){
                let type=dom.attr('data-type'),name=dom.attr('data-name');
                if(!type){
                    return '<td>-</td>'
                }else if(type=='text'){

                    return '<td data-item="'+item+'"><input type="text"  class="form-control" name="'+name+'" value="'+(val&&val[name]?val[name]:'')+'" '+(dom.attr('data-readonly')?dom.attr('data-readonly'):'')+'></td>'
                }else if(type=='select'){
                    let s='<select class="form-control" name="'+name+'">';
                    $.each( dom.attr('data-list').split(','),function (k,v){
                        s +='<option value="'+v+'" '+(val&&val[name]&&val[name]==v?'selected':'')+'>'+v+'</option>';
                    } )
                    s +='</select>';
                    return '<td data-item="'+item+'">'+s+'</td>'
                }else if(type=='set'){
                    return '<td><a href="javascript:;" class="add"><i class="fas fa-check"></i> 保存</a> <a href="javascript:;" class="exit" style="margin-left: 10px;color: #ff0000!important;"><i class="fas fa-times"></i> 取消</a></td>'
                }else if(type=='date'){
                    return '<td data-item="'+item+'"><input type="text"  class="form-control v-input-date" name="'+name+'" value="'+(val&&val[name]?val[name]:'')+'" autocomplete="off"></td>'
                }
            }
            let html='';
            table.each(function (item){

                html +=setVal($(this),item);
            });
            return html;
        }
        let replaceHtml=function (tmp,val){
            let reg = /@\{(.+?)\}/g;
            let res = tmp.match(reg);
            if(res){
                $.each(res,function (k,v){
                    let id=v.replace(/\@{(.+?)\}/,"$1");
                    tmp=tmp.replace(v,val[ id ]);
                })
            }
            return tmp;


        }
        let _setHtml=function (table,data){
            let html='';
            table.each(function (item){
                let name=$(this).attr('data-name');
                if(name&&data[name]){
                    if($(this).find('span').length>0){
                        html +='<td data-name="'+name+'">'+replaceHtml($(this).find('span').html(),data)+'</td>';
                    }else{
                        html +='<td data-name="'+name+'">'+data[name]+'</td>';
                    }

                }else{
                    if($(this).find('span').length>0){
                        html +='<td>'+replaceHtml($(this).find('span').html(),data)+'</td>';
                    }else{
                        html +='<td></td>';
                    }

                }
            });
            return html;
        },_save=function (table,object,callback){
            ajax({
                data:{
                    action:table,
                    data:object
                },
                success:function (res){
                    callback(res);
                }
            })
        }

        let _prizesetting=function (){

            $('.activity-table>tbody [data-switch]').off('change').on('change', function () {
                let checked=$(this).prop('checked'),id=$(this).data('id'),self=$(this);
                ajax({
                    data:{
                        action:'status',
                        id:id,
                        status:checked?2:1
                    },
                    success:function (res){
                        $('#renewMsg').html(res);
                    },error:function (res){
                        $('#renewMsg').html(res);
                        self.prop('checked',!checked)
                    }
                })
            });


        $('.add-activity').off('click').on('click',function (){
            $('.activity-table>tbody').append('<tr data-add>'+(_setTable($('.activity-table>thead>tr>th')))+'</tr>');
            $('input.v-input-date').datetimepicker({
                minView: "month", //选择日期后，不会再跳转去选择时分秒
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                todayBtn:  1,
                autoclose: 1,
            });
            $('.activity-table>tbody>tr[data-add] .exit').off("click").on("click",function (){
                  $(this).closest('tr').remove();
            })
            $('.activity-table>tbody>tr[data-add] .add').off("click").on("click",function (){
                let self=$(this),object={ };
                $(this).closest('tr').children('td[data-item]').each(function (){
                    let s=$(this).children('[name]')
                    object[ s.attr('name')  ]=s.val();
                })
                _save('prizesetting',object,function (res){
                    self.closest('tr').remove();
                    $('.activity-table>tbody').append('<tr data-data=\''+JSON.stringify(res)+'\'>'+(_setHtml($('.activity-table>thead>tr>th'),res))+'</tr>');
                    _prizesetting();
                });
            })




        })
            $('.activity-table>tbody .edit').off('click').on('click',function (){

                let tr=$(this).closest('tr'),object=JSON.parse(tr.attr("data-data"));

                tr.hide().after( '<tr data-edit>'+(_setTable($('.activity-table>thead>tr>th'),object))+'</tr>' );
                $('input.v-input-date').datetimepicker({
                    minView: "month", //选择日期后，不会再跳转去选择时分秒
                    language:  'zh-CN',
                    format: 'yyyy-mm-dd',
                    todayBtn:  1,
                    autoclose: 1,
                });
                $('.activity-table>tbody>tr[data-edit] .exit').off("click").on("click",function (){
                    $(this).closest('tr').prev('tr').show();
                    $(this).closest('tr').remove();

                })
                $('.activity-table>tbody>tr[data-edit] .add').off("click").on("click",function (){
                    let self=$(this),object={ };
                    $(this).closest('tr').children('td[data-item]').each(function (){
                        let s=$(this).children('[name]')
                        object[ s.attr('name')  ]=s.val();
                    })
                    _save('prizesetting',object,function (res){
                        self.closest('tr').prev('tr').attr('data-data',JSON.stringify(res)).show().html(_setHtml($('.activity-table>thead>tr>th'),res));;
                        if(res.status.toString()=="2"){
                            self.closest('tr').prev('tr').find('input[name="status"][data-switch]').prop('checked',true);
                        }
                        self.closest('tr').remove();
                        _prizesetting();
                    });
                })
            })
    }
        _prizesetting();
    })
</script>