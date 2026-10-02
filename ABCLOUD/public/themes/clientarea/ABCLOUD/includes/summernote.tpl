<link href="/themes/clientarea/ABCLOUD/assets/libs/summernote/summernote-bs4.min.css?v=3.0.0" rel="stylesheet" type="text/css">
<script src="/themes/clientarea/ABCLOUD/assets/libs/summernote/summernote-bs4.min.js?v=3.0.0"></script>
<script src="/themes/clientarea/ABCLOUD/assets/libs/summernote/lang/summernote-zh-CN.min.js?v=3.0.0"></script>
<script>
$(document).ready(function(){
	$(".summernote").summernote({
		placeholder: '请输入您的问题',
		height: [height],
		lang: 'zh-CN',
		tabsize: 4,
		minHeight: null,
		maxHeight: null,
		focus: !0,
	    toolbar: [//工具栏配置
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['para', ['ul', 'ol', 'paragraph']],
        ],
	})
});
</script>
