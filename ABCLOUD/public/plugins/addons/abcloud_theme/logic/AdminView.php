<?php
namespace addons\abcloud_theme\logic;

/**
 * Native plugin admin renderer.  The page is rendered by the host admin
 * controller after authentication; this class contains no login, license,
 * filesystem bootstrap, or direct database access.
 */
class AdminView
{
    public static function render(array $context)
    {
        $page = (string)($context['page'] ?? 'carousel');
        $allowed = ['dashboard','carousel','feature','topnav','footernav','web_module','popup','config','carousel_global','resources','operation_log'];
        if (!in_array($page, $allowed, true)) $page = 'carousel';
        $context['page'] = $page;
        if (is_object($context['items'] ?? null) && method_exists($context['items'], 'toArray')) $context['items'] = $context['items']->toArray();
        $context['items'] = is_array($context['items'] ?? null) ? $context['items'] : [];
        $context['configs'] = is_array($context['configs'] ?? null) ? $context['configs'] : [];
        $context['configMap'] = is_array($context['configMap'] ?? null) ? $context['configMap'] : [];
        if (is_object($context['logs'] ?? null) && method_exists($context['logs'], 'toArray')) $context['logs'] = $context['logs']->toArray();
        $context['logs'] = is_array($context['logs'] ?? null) ? $context['logs'] : [];
        $context['counts'] = is_array($context['counts'] ?? null) ? $context['counts'] : [];
        $context['adminName'] = trim((string)($context['adminName'] ?? '')) ?: '管理员';
        $context['csrfToken'] = (string)($context['csrfToken'] ?? '');
        $context['pageUrl'] = (string)($context['pageUrl'] ?? '');
        $context['apiUrl'] = (string)($context['apiUrl'] ?? $context['pageUrl'] ?? '');
        $context['assetUrl'] = rtrim((string)($context['assetUrl'] ?? '/plugins/addons/abcloud_theme/assets'), '/');
        $context['publicUrl'] = rtrim((string)($context['publicUrl'] ?? '/abcloud/content'), '/');
        $context['picker'] = !empty($_GET['picker']);

        ob_start();
        require dirname(__DIR__) . '/template/admin.php';
        return (string)ob_get_clean();
    }
}
