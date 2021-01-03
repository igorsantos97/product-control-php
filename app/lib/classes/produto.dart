class Produto {
  String iD;
  String dESCRICAO;
  String vALOR;
  String sTATUS;

  Produto({this.iD, this.dESCRICAO, this.vALOR, this.sTATUS});

  Produto.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    dESCRICAO = json['DESCRICAO'];
    vALOR = json['VALOR'];
    sTATUS = json['STATUS'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['DESCRICAO'] = this.dESCRICAO;
    data['VALOR'] = this.vALOR;
    data['STATUS'] = this.sTATUS;
    return data;
  }
}
