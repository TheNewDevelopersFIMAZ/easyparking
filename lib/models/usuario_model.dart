import 'dart:convert';

UsuariosModel usuariosModelFromJson(String str) => UsuariosModel.fromJson(json.decode(str));

String usuariosModelToJson(UsuariosModel data) => json.encode(data.toJson());

class UsuariosModel {
    String id;
    String nombreUsuario;
    String nombre;
    String apellido;
    String email;
    String password;
    int numeroTelefono;
    String tipoCarro;
    String marcaCarro;
    String placasCarro;
    String colorCarro;
    bool token;

    UsuariosModel({
        this.id = "",
        this.nombreUsuario = "",
        this.nombre = "",
        this.apellido = "",
        this.email = "",
        this.password = "",
        this.numeroTelefono = 0,
        this.tipoCarro = "",
        this.marcaCarro = "",
        this.placasCarro = "",
        this.colorCarro = "",
        this.token = true
    });

    factory UsuariosModel.fromJson(Map<String, dynamic> json) => UsuariosModel(
        id: json["id"],
        nombreUsuario: json["nombre_usuario"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        password: json["password"],
        numeroTelefono: json["numero_telefono"],
        tipoCarro: json["tipo_carro"],
        marcaCarro: json["marca_carro"],
        placasCarro: json["placas_carro"],
        colorCarro: json["color_carro"],
        token: json["token"]
    );

    Map<String, dynamic> toJson() => {
        //"id": id,
        "nombre_usuario": nombreUsuario,
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "password": password,
        "numero_telefono": numeroTelefono,
        "tipo_carro": tipoCarro,
        "marca_carro": marcaCarro,
        "placas_carro": placasCarro,
        "color_carro": colorCarro,
        //"returnSecureToken": token
    };
}
