class CepModel {
  String cep = '';
  String addressType = '';
  String addressName = '';
  String address = '';
  String state = '';
  String district = '';
  String lat = '';
  String lng = '';
  String city = '';
  String cityIbge = '';
  String ddd = '';

  // int id = 0;
  // double valor = 0.0;
  // bool casado = false;
  // DateTime dataCadastro = DateTime.now();

  CepModel();

  CepModel.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    addressType = json['address_type'];
    addressName = json['address_name'];
    address = json['address'];
    state = json['state'];
    district = json['district'];
    lat = json['lat'];
    lng = json['lng'];
    city = json['city'];
    cityIbge = json['city_ibge'];
    ddd = json['ddd'];
  }
}
