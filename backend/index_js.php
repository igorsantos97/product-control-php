<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Content-Type: application/json; charset=UTF-8');

require_once 'classes/Class.Crud.php';
require_once 'classes/Class.Conexao.php';

$conexao = Conexao::getConexao();
Crud::SetConexao($conexao);

$uri = (basename($_SERVER['REQUEST_URI']));

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if ($uri == 'produto') {
        $dados = Crud::select('SELECT * FROM tb_produto', [], TRUE);
    } elseif (is_numeric($uri)) {
        $dados = Crud::select('SELECT * FROM tb_produto WHERE id = :id', ['id' => $uri], FALSE);
        echo json_encode($dados);
        exit;
    } else {
        http_response_code(406);
        echo json_encode(['mensagem' => 'O ID deve ser numerico']);
        exit;
    }

    if (empty($dados)) {
        http_response_code(404);
        echo json_encode(['mensagem' => 'O ID não existe']);
    } else {
        echo json_encode($dados);
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $descricao = $_POST['descricao'] ?? '';
    $valor = $_POST['valor'] ?? '';
    $status = $_POST['status'] ?? '';

    if (empty($descricao)) {
        echo json_encode(['mensagem' => 'Informe a descricao']);
        http_response_code(406);
        exit;
    }

    if ($valor <= 0) {
        echo json_encode(['mensagem' => 'Coloque um valor maior que 0']);
        http_response_code(406);
        exit;
    }

    if (empty($status)) {
        echo json_encode(['mensagem' => 'Informe a status']);
        http_response_code(406);
        exit;
    }

    Crud::setTabela('tb_produto');
    $retorno = Crud::insert(['DESCRICAO' => $descricao, 'VALOR' => $valor, 'STATUS' => $status]);


    if ($retorno) {
        http_response_code(201);
        echo json_encode(['mensagem' => 'Inserido com Sucesso']);
    } else {
        http_response_code(500);
        echo json_encode(['mensagem' => 'Erro Interno no Servidor']);
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'PUT') {
    parse_str(file_get_contents('php://input'), $_PUT);

    $data = json_decode(file_get_contents('php://input'), true);

    $id =  $_PUT['id'] ?? '';
    $descricao =  $_PUT['descricao'] ?? '';
    $valor = $_PUT['valor'] ?? '';
    $status = $_PUT['status'] ?? '';


    if (empty($descricao)) {
        echo json_encode(['mensagem' => 'Informe o Produto']);
        http_response_code(406);
        exit;
    }

    if ($valor <= 0) {
        echo json_encode(['mensagem' => 'Coloque um valor maior que 0']);
        http_response_code(406);
        exit;
    }

    if (empty($status)) {
        echo json_encode(['mensagem' => 'Informe o Status']);
        http_response_code(406);
        exit;
    }

    if (!is_numeric($id)) {
        http_response_code(406);
        echo json_encode(['mensagem' => 'Parâmetro Inválido']);
    } else {
        $dados = Crud::select('SELECT id FROM tb_produto WHERE id = :id', ['id' => $id], FALSE);
        if (!empty($dados)) {
            Crud::setTabela('tb_produto');
            $retorno = Crud::update(['DESCRICAO' => $descricao, 'VALOR' => $valor, 'STATUS' => $status], ['ID' => $id]);
            if ($retorno) {
                http_response_code(202);
                echo json_encode(['mensagem' => 'Atualizado com Sucesso']);
            } else {
                http_response_code(500);
                echo json_encode(['mensagem' => 'Erro Interno no Servidor']);
            }
        } else {
            http_response_code(404);
            echo json_encode(['mensagem' => 'Parâmetro não encontrado']);
        }
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'DELETE') {

    if (!is_numeric($uri)) {
        http_response_code(406);
        echo json_encode(['mensagem' => 'Parâmetro Inválido']);
    } else {
        $dados = Crud::select('SELECT id FROM tb_produto WHERE id = :id', ['id' => $uri], FALSE);
        if (!empty($dados)) {
            Crud::setTabela('tb_produto');
            $retorno = Crud::delete(['id' => $uri]);
            if ($retorno) {
                http_response_code(202);
                echo json_encode(['mensagem' => 'Excluído com Sucesso']);
            } else {
                http_response_code(500);
                echo json_encode(['mensagem' => 'Erro Interno no Servidor']);
            }
        } else {
            http_response_code(404);
        }
    }
}
