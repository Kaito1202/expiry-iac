Terraform作業ログ

## Terraform インストール
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

## プロジェクトフォルダ作成
```
ExpiryIaC/
├── main.tf             # リソース定義（ECR, VPC, EKS など）
├── variables.tf        # 変数定義
├── outputs.tf          # 出力値
└── terraform.tfvars    # 実際の値
```
## ECRリポジトリ定義を記述
main.tf,variables.tf,terraform.tfvars,outputs.tfを書き換える

## ECRリポジトリ構築
```
terraform init        # 初期化（依存モジュールDL）
terraform plan        # 何が作られるか確認
terraform apply       # 実行！構築スタート（15〜20分）
```

## EKSクラスタの作成（NodeGroupつき）

・main.tf に ECRの下にEKS/VPCの構成を追記  
・必要なProviderモジュールを追加
```
terraform init
```
・動作確認
```
terraform plan
terraform apply
```
・applyが終わったら
```
terraform output
```

## kubectl を新しい EKS クラスタと接続する
```
aws eks --region ap-northeast-1 update-kubeconfig --name expiry-eks
```
これによって、 ~/.kube/config に新しいクラスタ情報が追記され、kubectl が使えるようになる  

・ノードの確認
```
kubectl get nodes
```
この時、cluster_endpoint_public_access=faleseになっているとkubectlでアクセスできない
以下をmain.tfに追加する
```
cluster_endpoint_public_access       = true
cluster_endpoint_private_access      = true
cluster_endpoint_public_access_cidrs = ["パブリックIPアドレス/32"]
```
また、kubectl が認証情報（credentials）を持っていない状態で EKS にアクセスしようとすると失敗する  
今のユーザ/ロール確認
```
aws sts get-caller-identity
```
{
    "UserId": "AROATHVQLI7UJIS2RDWTE:MyPC",
    "Account": "222634395624",
    "Arn": "arn:aws:sts::222634395624:assumed-role/AWSReservedSSO_AdministratorAccess_83bdb94eb90a76c2/MyPC"
}