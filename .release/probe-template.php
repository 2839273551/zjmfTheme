<?php
require '/www/wwwroot/idc.yunxnet.cn/vendor/thinkphp/base.php';
foreach (['compiler', 'parse', 'parseInclude', 'parseTemplateFile'] as $name) {
    $method = new ReflectionMethod(think\Template::class, $name);
    echo $name . ': ';
    foreach ($method->getParameters() as $parameter) echo $parameter->getName() . ' ';
    echo PHP_EOL;
}
