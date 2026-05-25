Feature: API Usuarios

  Background:
    * url 'http://localhost:8000'


  Scenario: Consultar todos los usuarios

    Given path '/api/usuarios'
    When method get
    Then status 200

    And match response.ok == true
    And match response.data == '#[]'


  Scenario: Consultar usuario inexistente

    Given path '/api/usuarios/999999'
    When method get
    Then status 404

    And match response.ok == false
    And match response.msg == 'El usuario no existe'


  Scenario: Crear usuario correctamente

    * def usuario =
    """
    {
      "nombres": "Juan",
      "apellidos": "Perez",
      "correo": "juan@test.com",
      "telefonos": 123456,
      "celular": 3001234567,
      "direccion": "Calle 123",
      "ciudad": "Cali"
    }
    """

    Given path '/api/usuarios'
    And request usuario
    When method post
    Then status 201

    And match response.ok == true
    And match response.msg == 'Usuario creado correctamente'

    And match response.data.nombres == usuario.nombres
    And match response.data.apellidos == usuario.apellidos
    And match response.data.correo == usuario.correo


  Scenario: Validar creación con datos incompletos

    * def usuario =
    """
    {
      "nombres": "",
      "correo": ""
    }
    """

    Given path '/api/usuarios'
    And request usuario
    When method post
    Then status 400

    And match response.ok == false
    And match response.msg == 'Faltan campos obligatorios'


  Scenario: Actualizar usuario

    # CREAR USUARIO TEMPORAL
    * def usuario =
    """
    {
      "nombres": "Temporal",
      "apellidos": "Test",
      "correo": "temporal@test.com",
      "telefonos": 111,
      "celular": 222,
      "direccion": "Temporal",
      "ciudad": "Cali"
    }
    """

    Given path '/api/usuarios'
    And request usuario
    When method post
    Then status 201

    * def userId = response.data.id

    # ACTUALIZAR
    * def updateRequest =
    """
    {
      "nombres": "Juan Actualizado",
      "ciudad": "Bogota"
    }
    """

    Given path '/api/usuarios', userId
    And request updateRequest
    When method put
    Then status 200

    And match response.ok == true
    And match response.msg == 'Usuario actualizado correctamente'

    And match response.data.nombres == 'Juan Actualizado'
    And match response.data.ciudad == 'Bogota'


  Scenario: Actualizar usuario inexistente

    * def updateRequest =
    """
    {
      "nombres": "No Existe"
    }
    """

    Given path '/api/usuarios/999999'
    And request updateRequest
    When method put
    Then status 404

    And match response.ok == false
    And match response.msg == 'El usuario no existe'


  Scenario: Eliminar usuario

    # CREAR USUARIO TEMPORAL
    * def usuario =
    """
    {
      "nombres": "Eliminar",
      "apellidos": "Test",
      "correo": "eliminar@test.com",
      "telefonos": 111,
      "celular": 222,
      "direccion": "Temporal",
      "ciudad": "Cali"
    }
    """

    Given path '/api/usuarios'
    And request usuario
    When method post
    Then status 201

    * def userId = response.data.id

    # ELIMINAR
    Given path '/api/usuarios', userId
    When method delete
    Then status 200

    And match response.ok == true
    And match response.msg == 'Usuario eliminado correctamente'


  Scenario: Eliminar usuario inexistente

    Given path '/api/usuarios/999999'
    When method delete
    Then status 404

    And match response.ok == false
    And match response.msg == 'El usuario no existe'