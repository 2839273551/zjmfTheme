{if $TplName != 'login' && $TplName != 'register' && $TplName != 'pwreset' && $TplName != 'bind' && $TplName != 'loginaccesstoken'}
				</div>
			</div>
		</div>

		<footer class="footer">
			<div class="container-fluid">
				<div class="row align-items-center">
					<div class="col-sm-6">
						&copy; {$Setting.company_name} 版权所有.
					</div>
					<div class="col-sm-6 text-sm-right d-none d-sm-block">
						<span class="text-muted">高可用云计算与在线业务运营平台</span>
					</div>
				</div>
			</div>
		</footer>
{/if}

<script src="/themes/clientarea/ABCLOUD/assets/js/app.js?v=3.0.0"></script>
{php}
$hooks = hook('client_area_footer_output');
foreach (array_unique((array) $hooks) as $item) {
    echo $item;
}
{/php}
</body>

</html>
