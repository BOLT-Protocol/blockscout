<h1 align="center">BlockScout</h1>

## 安裝

```
bash <(curl https://raw.githubusercontent.com/BOLT-Protocol/blockscout/tidebit/shell/install.sh -kL) -h 172.31.8.45 -p nGtY3XMeetASmfH8 -w https://rpc.tidebit.network -r ws://35.153.31.115:8546
```

上面的參數分別代表

```
Usage: bash <(curl https://raw.githubusercontent.com/.../install.sh -kL) [-h db_host(require)] [-p db_password(require)] [-w wsapi(require)] [-r rpcapi(require)]
  -h : postgres host
  -p : postgres password
  -w : eth node websocket api, ex: https://127.0.0.1
  -r : eth node rpc https api, ex: ws://127.0.0.1
```

其中執行到一半會需要手動輸入

```
正複製到 'blockscout'...
remote: Enumerating objects: 131052, done.
remote: Counting objects: 100% (1353/1353), done.
remote: Compressing objects: 100% (762/762), done.
remote: Total 131052 (delta 750), reused 948 (delta 528), pack-reused 129699
接收物件中: 100% (131052/131052), 42.60 MiB | 27.42 MiB/s, 完成.
處理 delta 中: 100% (88156/88156), 完成.
Could not find Hex, which is needed to build dependency :ex_doc
Shall I install Hex? (if running non-interactively, use "mix local.hex --force") [Yn] 
```


## 多國語系

'/blockscout/apps/block_scout_web/priv/gettext/${locale}/LC_MESSAGES'

這邊會發現簡體中文的 locale 我建立在 `fr` 資料夾上，原因是因為這邊使用 `zh-Hans` 或 `zh-Hans-HK` 等字眼時

在下

`cd apps/block_scout_web; mix gettext.extract --merge; cd -`

編譯時都會出錯，所以這邊使用 `fr` 來代替

<p align="center">Blockchain Explorer for inspecting and analyzing EVM Chains.</p>
<div align="center">

[![Blockscout](https://github.com/poanetwork/blockscout/workflows/Blockscout/badge.svg?branch=master)](https://github.com/poanetwork/blockscout/actions) [![Coverage Status](https://coveralls.io/repos/github/poanetwork/blockscout/badge.svg?branch=master)](https://coveralls.io/github/poanetwork/blockscout?branch=master) [![Join the chat at https://gitter.im/poanetwork/blockscout](https://badges.gitter.im/poanetwork/blockscout.svg)](https://gitter.im/poanetwork/blockscout?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

</div>

BlockScout provides a comprehensive, easy-to-use interface for users to view, confirm, and inspect transactions on EVM (Ethereum Virtual Machine) blockchains. This includes the POA Network, xDai Chain, Ethereum Classic and other **Ethereum testnets, private networks and sidechains**.

See our [project documentation](https://docs.blockscout.com/) for detailed information and setup instructions.

Visit the [POA BlockScout forum](https://forum.poa.network/c/blockscout) for FAQs, troubleshooting, and other BlockScout related items. You can also post and answer questions here.

You can also access the dev chatroom on our [Gitter Channel](https://gitter.im/poanetwork/blockscout).

## About BlockScout

BlockScout is an Elixir application that allows users to search transactions, view accounts and balances, and verify smart contracts on the Ethereum network including all forks and sidechains.

Currently available full-featured block explorers (Etherscan, Etherchain, Blockchair) are closed systems which are not independently verifiable.  As Ethereum sidechains continue to proliferate in both private and public settings, transparent, open-source tools are needed to analyze and validate transactions.

## Supported Projects

BlockScout supports a number of projects. Hosted instances include POA Network, xDai Chain, Ethereum Classic, Sokol & Kovan testnets, and other EVM chains. 

- [List of hosted mainnets, testnets, and additional chains using BlockScout](https://docs.blockscout.com/for-projects/supported-projects)
- [Hosted instance versions](https://docs.blockscout.com/about/use-cases/hosted-blockscout)


## Getting Started

See the [project documentation](https://docs.blockscout.com/) for instructions:
- [Requirements](https://docs.blockscout.com/for-developers/information-and-settings/requirements)
- [Ansible deployment](https://docs.blockscout.com/for-developers/ansible-deployment)
- [Manual deployment](https://docs.blockscout.com/for-developers/manual-deployment)
- [ENV variables](https://docs.blockscout.com/for-developers/information-and-settings/env-variables)
- [Configuration options](https://docs.blockscout.com/for-developers/configuration-options)


## Acknowledgements

We would like to thank the [EthPrize foundation](http://ethprize.io/) for their funding support.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution and pull request protocol. We expect contributors to follow our [code of conduct](CODE_OF_CONDUCT.md) when submitting code or comments.

## License

[![License: GPL v3.0](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
