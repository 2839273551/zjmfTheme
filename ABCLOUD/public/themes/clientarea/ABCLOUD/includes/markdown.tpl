<!-- markdown 存在的问题: class名称和项目名称冲突 导致工具栏字体图标无法显示 -->

<!-- <link href="/themes/clientarea/ABCLOUD/assets/libs/markdown/css/bootstrap-markdown.min.css?v=3.0.0" rel="stylesheet" type="text/css">
<link href="/themes/clientarea/ABCLOUD/assets/libs/markdown/css/htmleaf-demo.css?v=3.0.0" rel="stylesheet" type="text/css">
<script src="/themes/clientarea/ABCLOUD/assets/libs/markdown/js/bootstrap-markdown.js?v=3.0.0"></script>
<script src="/themes/clientarea/ABCLOUD/assets/libs/markdown/locale/bootstrap-markdown.zh.js?v=3.0.0"></script>
<script>
  $(function () {
    $(".markdown").markdown({autofocus:false,savable:false, language:'zh'})
  })
</script> -->

<link href="/themes/clientarea/ABCLOUD/assets/libs/markdown-editor/dist/css/bootstrap-markdown-editor.css?v=3.0.0" rel="stylesheet" type="text/css">

<script src="/themes/clientarea/ABCLOUD/assets/libs/markdown-editor/js/ace.js?v=3.0.0"></script>
<script src="/themes/clientarea/ABCLOUD/assets/libs/markdown-editor/js/marked.min.js?v=3.0.0"></script>
<script src="/themes/clientarea/ABCLOUD/assets/libs/markdown-editor/dist/js/bootstrap-markdown-editor.js?v=3.0.0"></script>
<script>
  $(function () {
    $(".markdown").markdownEditor({
      preview: true,
			onPreview: function (content, callback) {
				callback(marked(content));
			}
    })
  })
</script>
