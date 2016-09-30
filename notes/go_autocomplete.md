遇到一个诡异的事情

问题是这样 go autocomplete 对 import 进来的 package 不生效，比如 fmt

然后运行 `gocode/_testing` 目录下的 all.bash 却提示全部 PASS

一番调试后发现我系统包含两个 gocode，一个是在 $GOPATH/bin 下面的 gocode，一个
是 YCM 自带的 gocode，而用 YCM 的 gocode 跑 test 是不能成功的

由于我用的 YCM 实现 go 的 autocomplete，所以每次启动的都是 YCM 的 gocode，导致
vim 中 autocomplete 失败

解决办法，在 YCM 相关目录下创建一个 symlink 到 $GOPATH/bin/gocode
