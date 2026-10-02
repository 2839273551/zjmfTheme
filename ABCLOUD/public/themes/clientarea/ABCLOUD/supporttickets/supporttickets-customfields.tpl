
<link href="/themes/clientarea/ABCLOUD/assets/libs/dropzone/min/dropzone.min.css?v=3.0.0" rel="stylesheet"
      type="text/css" />
<script src="/themes/clientarea/ABCLOUD/assets/libs/dropzone/min/dropzone.min.js?v=3.0.0"></script>
<div class="input-group mb-1 attachment-group">
    <div class="custom-file">
        <label class="custom-file-label text-truncate" for="inputAttachment1" data-default="Choose file">
            {$Lang.select_file}
        </label>
        <input type="file" class="custom-file-input" name="attachments[]" id="inputAttachment1">
    </div>
    <div class="input-group-append">
        <button class="btn btn-secondary" type="button" id="btnTicketAttachmentsAdd">
            <i class="fas fa-plus"></i>
           {$Lang.add_more}
        </button>
    </div>
</div>
<div class="text-muted">
    <small>{$Lang.allowed_suffixes}: .jpg、.gif、.jpeg、.png</small>
</div>
