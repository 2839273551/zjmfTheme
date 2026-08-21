<style>
    .cycles-setting .form-group>div{
        display: flex;
        align-items: center;
    }
</style>
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

                        <div class="table-body" id="server-product"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<script src="/plugins/addons/{$GzhxPluginPath}/template/js/layer/layer.js"></script>
<script>
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
    let GzhxLoading=function(str){



        return layer.msg(str, {
            time: 0,
            icon:16

            ,shade: 0.3,zIndex: layer.zIndex

            ,success:function (layero) {

                layer.setTop(layero);

            }

        });

    }
    let ajax=function (option){
        let index=GzhxLoading(option.load||"加载中……")
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

                    layer.close(index);

                    if( t.status==1 ){
                        if(option.success)  option.success(t.info);
                    }else{
                        if(option.error){
                            option.error(t.info);
                        }else{
                            layer.msg(t.info);
                        }
                    }
                },

                error: function (request, status, errorThrown) {
                    layer.close(index);
                    if(option.error){
                        option.error("请检查宝塔防火墙是否拦截，如果拦截请关闭或者加白名单");
                    }else{
                        layer.msg("请检查宝塔防火墙是否拦截，如果拦截请关闭或者加白名单");
                    }
                }
            }
        );
    }
    $(function (){
        let query=queryToJson();
        let index=GzhxLoading("处理中……");
        $.ajax({
            url: './zjmf_finance_api/addpage?request_time=' + new Date().getTime(),
            type: "GET",
            headers: {
                //     "X-Requested-With": "XMLHttpRequest",
            },

            success: function (addpage) {
                $.ajax({
                    url: './get_upstream_products?id='+query.id+'&languagesys=CN&request_time='+new Date().getTime(),
                    type: "GET",
                    headers: {
                        //     "X-Requested-With": "XMLHttpRequest",
                    },

                    success: function (t) {

                        layer.close(index);

                        if( t.status==200 ){
                            ajax({
                                data:{
                                    action:'check',
                                    data:t
                                },
                                success:function (r){
                                    /**S***/

                                    let Groups=[];
                                    Groups.push('<option value="">请选择分组</option>');
                                    Groups.push('<option value="-1">新建分组</option>');
                                    $.each(addpage.data.groupdata,function (k,v){
                                        Groups.push('<option value="'+v.id+'">'+v.name+'</option>')
                                    })
                                    let Menu=[],MenuType={ };
                                    Menu.push('<option value="">请选择导航</option>')
                                    $.each(addpage.data.ptype,function (k,v){
                                        MenuType[v.name]=v.id;
                                        Menu.push('<option value="'+v.id+'">'+v.name+'</option>')
                                    })
                                    $('#server-product').empty().html('<div style="padding: 20px;margin:10px;box-sizing: border-box;border: 1px solid #333333;"><h3>提示：新建分组在商品中【默认分组】下，如需要调整请导入后到商品列表中自行调整</h3>利润百分比(%)：<input type="text" name="profit" value="30">汇率：<input type="text" name="rate" value="'+r.server.rate+'"></div>');
                                    $.each( r.server.data,function (k,v){
                                        let type='';
                                        let html='<div style="padding: 20px;margin:10px;box-sizing: border-box;border: 1px solid #333333;"><table class="table table-bordered table-hover">';
                                        html +='<caption style="caption-side:top;">'+v.name+'：<select name="group'+v.id+'" class="group-select">'+Groups.join('')+'</select><select name="menu'+v.id+'">'+Menu.join('')+'</select> <button type="button" class="btn btn-danger btn-sm update-files" data-vid="'+v.id+'" data-type="'+v.name+'">批量导入</button></caption>';
                                        html +='<thead class="thead-light">' +
                                            '<tr>' +
                                            '<th class="checkbox" style="width: 100px;">' +
                                            '<div class="custom-control custom-checkbox thead-checkbox">' +
                                            '<input type="checkbox" class="custom-control-input" id="customCheckHead'+v.id+'" name="headCheckbox" checked>' +
                                            '<label class="custom-control-label" for="customCheckHead'+v.id+'">&nbsp;</label>' +
                                            '</div>' +
                                            '</th>' +
                                            '<th style="width: 100px;">ID</th>' +
                                            '<th style="width: 300px;">商品名称</th>' +
                                            '<th>TYPE</th>' +
                                            '</tr></thead><tbody>'
                                        $.each( v.products,function (kk,vv){
                                            if(type==''){
                                                type=vv.type;
                                            }
                                            html +='<tr>' +
                                                '<td>'+(r.client.hasOwnProperty(vv.id)?'':('' +
                                                    '<div class="custom-control custom-checkbox">' +
                                                    '<input type="checkbox" class="custom-control-input row-checkbox" value="'+vv.id+'" data-name="'+vv.name+'" data-vid="'+v.id+'" id="customCheck'+vv.id+'" checked>' +
                                                    '<label class="custom-control-label" for="customCheck'+vv.id+'">&nbsp;</label>' +
                                                    '</div>'))+'</td>' +
                                                '<td>'+vv.id+'</td>' +
                                                '<td>'+vv.name+'</td>' +
                                                '<td>'+vv.type+'</td>' +
                                                '</tr>'
                                        });
                                        html +='</tbody></table></div>';
                                        $('#server-product').append(html);
                                        switch (type){
                                            case 'cdn':$('select[name="menu'+v.id+'"]').val(MenuType['云服务器']);break;
                                            case 'cloud':$('select[name="menu'+v.id+'"]').val(MenuType['云服务器']);break;
                                            case 'hostingaccount':$('select[name="menu'+v.id+'"]').val(MenuType['虚拟主机']);break;
                                            case 'server':$('select[name="menu'+v.id+'"]').val(MenuType['独立服务器']);break;
                                            case 'other':$('select[name="menu'+v.id+'"]').val(MenuType['其他']);break;
                                        }

                                    } )
                                    $('.thead-checkbox').off('click').on('click',function (){
                                        let self=$(this),checked=self.find('input[type="checkbox"]').prop('checked');
                                        self.closest('table').find('input[type="checkbox"]').prop('checked',checked);
                                    })
                                    $('.update-files').off('click').on('click',function (){
                                        let self=$(this),
                                            id=[],
                                            group_id=self.prev('select').prev('select').val(),
                                            menu=self.prev('select').val(),
                                            profit=$('#server-product input[name="profit"]').val(),
                                            rate=$('#server-product input[name="rate"]').val();
                                        if(!group_id){
                                            layer.msg("请选择要加入的分组");
                                            return false;
                                        }
                                        if(!menu){
                                            layer.msg("请选择要加入的导航");
                                            return false;
                                        }
                                        self.closest('table').find('tbody').find('input[type="checkbox"]:checked').each(function (){
                                            let ids=$(this).val(),name=$(this).data('name');
                                            id.push({
                                                id:ids,
                                                name:name
                                            })
                                        });
                                        if(id.length<1){
                                            layer.msg("请选择要同步的产品");
                                            return false;
                                        }
                                        let query=queryToJson();
                                        let fd = new FormData()

                                        fd.append("upstream_price_value",parseInt(profit)+100);
                                        fd.append("ptype",menu);
                                        fd.append("zjmf_finance_api_id",query.id);
                                        fd.append("rate",rate);
                                        $.each(id,function (k,v){
                                            fd.append("productnames["+v.id+"]",v.name);
                                        })
                                        let _save=function (gid){
                                            fd.append("gid",gid);
                                            let index=GzhxLoading("处理中……");
                                            $.ajax({
                                                url: './zjmf_finance_api/inputproduct?request_time='+new Date().getTime(),
                                                type: "POST",
                                                headers: {
                                                    //     "X-Requested-With": "XMLHttpRequest",
                                                },
                                                processData: false,
                                                contentType: false,
                                                data: fd,
                                                xhr: function () {
                                                    myXhr = $.ajaxSettings.xhr();
                                                    if (myXhr.upload) {


                                                    }

                                                    return myXhr;

                                                },
                                                complete:function(t){
                                                    layer.close(index);
                                                    if( t.status!=200 ){
                                                        layer.msg("网络错误");
                                                    }

                                                },
                                                success: function (t) {
                                                    console.log(t);
                                                    layer.close(index);

                                                    if( t.status==200 ){
                                                        layer.msg(t.msg,{
                                                            end:function (){
                                                                self.closest('table').closest('div').remove();
                                                            }
                                                        });

                                                    }else{


                                                        layer.msg(t.msg);

                                                    }



                                                }, fail: function (data) {
                                                    layer.msg("网络错误");

                                                }

                                            });
                                        }
                                        if(group_id-0>0){
                                            _save(group_id);
                                        }else{
                                            ajax({
                                                data:{
                                                    action:'save',
                                                    name:self.data('type')
                                                },success:function (gid){
                                                    $('.group-select').append('<option value="'+gid+'">'+self.data('type')+'</option>')
                                                    _save(gid);
                                                }
                                            })
                                        }

                                    })
                                    /**E***/
                                    console.log('get_upstream_products',product);
                                }
                            })

                        }else{


                            layer.msg(t.msg);

                        }



                    }, fail: function (data) {
                        layer.msg("网络错误");

                    }

                });
            }
        });


       /* ajax({
            data:{
                action:'get',
                uri:window.location.href
            },success:function (r){


            }
        })*/
    })
</script>

