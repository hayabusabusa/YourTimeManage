---
name: run-xcode-build
description: Build Xcode project and run the app on simulator or physical device.
---

# Run xcodebuild

Xcode プロジェクトを xcodebuild コマンドでビルドする。

## Workflow

### 1. Detect Xcode project

以下のコマンドを実行して対象となる Xcode プロジェクトファイル、もしくはワークスペースを検出する。

```bash
find . -maxdepth 1 \( -name "*.xcworkspace" -o -name "*.xcodeproj" \) | head -1
```

- `xcworkspace` ファイルが見つかった場合は、`xcworkspace` ファイルを優先して利用する。

### 2. Detect Build Scheme

以下のコマンドを実行してビルド対象となるスキームを検出する。

```bash
xcodebuild -list
```

- 上記コマンドにビルド対象となるファイルに応じたオプションの付与を行う。
  - `xcworkspace` ファイルが対象となる場合は `-workspace {workspace}.xcworkspace` オプションを付与する。
  - `xcodeproj` ファイルが対象となる場合は `-project {project}.xcodeproj` オプションを付与する。
- コマンドの結果からビルド対象となるスキームを以下の優先順位に応じて検出する。
  - 1: この skill 呼び出し時に指定されたスキームと同名のスキーム。
  - 2: この skill 呼び出し時に指定されたファイル、もしくはファイルのパス内に含まれる文字列と同名のスキーム。
  - 3: ビルド対象となる `xcworkspace` ファイルもしくは `xcodeproj` ファイルと同名のスキーム。
  - 4: スキーム一覧で一番最初に表示されているスキーム。

### 3. Get Device ID

以下のコマンドを実行してビルド時に利用するデバイスの ID を取得する。

```bash
xcrun simctl list devices booted -j
```

- `state` が `Booted` となっているデバイスを採用する。
- 利用可能なデバイスがない場合は、以下の手順で OS バージョンが最新のデバイスを起動する。
  - `xcrun simctl list devices -j` コマンドを実行してデバイス一覧を取得する。
  - 出力される JSON の内、以下の基準で iOS デバイスを選択し、`uuid` を `DEVICE_ID` として取得する。
    - 標準モデルのiPhone（iPhone 17、iPhone 16など）を優先する。
    - テストにはPro、Plus、Maxなどのバリエーションではなく、標準モデルを使用する。
    - 最新のiOSバージョンがインストールされたシミュレーターを使用する。
  - `xcrun simctl boot {uuid}` を実行してデバイスを起動する。

### 4. Build

以下のコマンドを実行してビルドを行う。

```bash
xcodebuild -project '${PROJECT}' -workspace '${WORKSPACE}' -scheme '${SCHEME}' -destination 'platform=iOS,id=${DEVICE_ID}'
```

- `-project`、`-workspace` オプションは、検出されたファイルに応じて付与する。
- `-scheme` オプションは、検出されたスキームを付与する。
- `-destination` オプションは、取得した `DEVICE_ID` を付与する。

## Swift Package Manager Commands Limitations

`swift run` および `swift test` コマンドは動作しないため、適切なiOSのテストおよびビルドを行うには手順に従って**代わりに`xcodebuild`を使用してください**。

- **iOS ターゲット**：このライブラリは iOS プラットフォームを対象としており、実行にはシミュレータまたは実機が必要です。Swift Package Manager の `swift run` および `swift test` コマンドは、macOS 互換のターゲットでのみ動作します。
- **Xcode プロジェクトとの統合**: Swift パッケージが Xcode プロジェクト (`.xcodeproj`) やワークスペースに統合されている場合、ビルドシステムは SPM を直接使用するのではなく、Xcode のビルドツールを使用することを想定しています。
- **フレームワークの依存関係**: iOSライブラリは、SPMのコマンドライン環境では利用できないiOS固有のフレームワークに依存していることがよくあります。
