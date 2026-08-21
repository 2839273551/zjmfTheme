<style>
    .gzhx-flex{
        display: flex;
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
                        <div class="table-body">
                            <form class="form save-activity">

                                <div class="form-group row">
                                    <label class="require">活动方式</label>
                                    <div class="col-sm-4">
                                        <select name="activity_type">
                                            <option value="单笔充值" {eq name="$Activity.setting.activity_type" value="单笔充值"}selected{/eq}>单笔充值</option>
                                            <option value="累积充值" {eq name="$Activity.setting.activity_type" value="累积充值"}selected{/eq}>累积充值</option>
                                            <option value="累积消费" {eq name="$Activity.setting.activity_type" value="累积消费"}selected{/eq}>累积消费</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="require">奖品类型</label>
                                    <div class="col-sm-4">
                                        <select name="activity_prize">
                                            <option value="优惠券" {eq name="$Activity.setting.activity_prize" value="优惠券"}selected{/eq}>优惠券</option>
                                            <option value="现金红包" {eq name="$Activity.setting.activity_prize" value="现金红包"}selected{/eq}>现金红包</option>
                                            <option value="代理级别" {eq name="$Activity.setting.activity_prize" value="代理级别"}selected{/eq}>代理级别</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label class="require">活动规则</label>
                                    <div class="col-sm-4">
                                        <textarea class="form-control" name="info" rows="10" required placeholder="不支持HTML代码">{$Activity.setting.info}</textarea>
                                    </div>
                                </div>
                                <div class="table-body" id="saveMsg" style="color: #ff0000;"></div>
                                <div class="form-group row">
                                    <label></label>
                                    <div class="col-sm-6">
                                        <button type="submit" class="btn btn-primary w-md">保存更改</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<script>

    $(function (){
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
        $('input.v-input-date').datetimepicker({
            minView: "month", //选择日期后，不会再跳转去选择时分秒
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            todayBtn:  1,
            autoclose: 1,
        });
        $('.save-activity').on("submit",function (){
            let object={ },data=$(this).serializeArray();
            console.log(data);
            $.each( data,function (k,v){
                object[ v.name ]=v.value;
            } )
            console.log(object);
            data.push({
                name:'action',
                value:'save'
            })
            ajax({
                data:data,
                success:function (res){
                    $('#saveMsg').html(res);
                    top.location.href="addons?_plugin=pay_activity&_controller=admin_index&_action=activity";
                },error:function (res){
                    $('#saveMsg').html(res);
                }
            })
            return false;
        });
    })
</script>