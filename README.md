# 開発用にローカルに仮想環境を構築する手順

# 準備

## ツール

- vagrant
- virtualbox
- gitクライアント(CUI)
- Vagrant box: centos/7
- Vagrantプラグイン: vagrant_vbguest

## その他

- Gitlab: ソースコード リポジトリ
- [任意] SourceTree: Gitクライアント(GUI)
- [任意] gitbash: WindowsでBashを叩けるCUI (コマンドプロンプト、Powershellの代替)


# 構築手順

## [初回のみ] ツールをインストールする (手動)

1. vagrantをインストールする  
   https://www.vagrantup.com/
1. virtualboxをインストールする  
   https://www.virtualbox.org/wiki/Downloads
1. gitをインストールする  
   https://git-scm.com/
1. vagrant boxをダウンロードする  
   `$ vagrant box add centos/7`
1. vagrantプラグインをダウンロードする  
   `$ vagrant plugin install vagrant-vbguest`
1. [任意] SourceTreeをインストールする  
   https://www.sourcetreeapp.com/
1. [任意] gitbashをインストールする  
   https://gitforwindows.org/


## 仮想環境の設定ファイル(Vagrantfile, provision/)を編集する (手動)

1. Vagrantfileプロジェクトをcloneする _*作業フォルダのパスは各自で読み替えてください
1. Vagrantファイル、プロビジョナの変数を編集する
    1. プロビジョナ(開発中のアプリ設定): provision/deploy_project.sh
        - (★各自)Gitlabユーザ名 *各自のログインID
        - (★各自)Gitlabパスワード *各自のパスワード

## ローカルに仮想環境を構築する (自動)

1. Vagrantを実行する (仮想環境を構築し、初回起動した状態となる)  
   `$ vagrant up`

以上


# 環境構築後の操作

- 仮想環境の状態を確認する  
   `$ vagrant status`

- 仮想環境にリモートアクセスする (仮想環境を構築したフォルダにて)  
   `$ vagrant ssh`  
   _*ssh情報は `$ vagrant ssh-config` で参照できる_  
   _*仮想環境へ接続する際のsshキーのパスは_ ./.vagrant/machines/default/virtualbox/private_key

- 仮想環境を停止する  
   `$ vagrant halt`

- 仮想環境を起動する(構築と同じコマンド)  
   `$ vagrant up`  
   _*初回は上記の手順内で起動される_

- 仮想環境を破棄する  
   `$ vagrant destroy`


# トラブルシューティング

- Windowsで構築する場合、共有フォルダの設定でエラーが出るかもしれません。  
  その場合、Vagrantfileの 'config.vm.synced\_folder' で 'type:' を書き換えると解消します  
  参考) https://www.vagrantup.com/docs/synced-folders/basic_usage.html
- Vagrantfile 内のネットワーク設定で port forward を設定する時、各自の端末内で指定したポート番号を別のシステムで使用している場合があります。ホストOS側のポート番号を変更してみてください