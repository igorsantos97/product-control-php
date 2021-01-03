<?php

require_once 'Class.Conexao.php';

// CRUD COMPLETO, TOTALMENTE REUTILIZÁVEL

class Crud
{
    private static $conexao;
    private static $tabela;

    public static function setConexao($conn)
    {
        self::$conexao = $conn;
    }

    public static function setTabela($nomeTabela)
    {
        self::$tabela = $nomeTabela;
    }

    public static function montaSqlInsert($arrayDados)
    {
        $campos = implode(',', array_keys($arrayDados));
        $params = ':' . implode(', :', array_keys($arrayDados));
        // a funcção array_keys() retorna apenas a chave da variável

        $sql = 'INSERT INTO ' . self::$tabela;
        $sql .= '(' . $campos . ')VALUES(' . $params . ')';
        return $sql;
    }

    public static function montaSqlDelete($arrayCondicoes)
    {
        $sql = 'DELETE FROM ' . self::$tabela;
        $sql .= ' WHERE ';

        foreach ($arrayCondicoes as $key => $value) {
            $sql .= " {$key} = :{$key} AND";
        }
        $sql = rtrim($sql, 'AND');
        // função rtrim() limpa espaço ou caracter a direita da string, 
        // se não for passado parametros, limpa apenas os campos vazios
        // função ltrim() faz o mesmo, só que do lado esquerdo
        return $sql;
    }

    public static function montaSqlUpdate($arrayDados, $arrayCondicoes)
    {
        $sql = 'UPDATE ' . self::$tabela . ' SET ';

        foreach ($arrayDados as $key => $value) {
            $sql .= "{$key} = :{$key}, ";
        }
        $sql = rtrim($sql, ', ');

        $sql .= ' WHERE ';

        foreach ($arrayCondicoes as $key => $value) {
            $sql .= " {$key} = :{$key} AND";
        }
        $sql = rtrim($sql, 'AND');

        return $sql;
    }

    public static function insert($arrayDados)
    {
        try {
            $sql = self::montaSqlInsert($arrayDados);
            $stm = self::$conexao->prepare($sql);

            foreach ($arrayDados as $key => $value) {
                $stm->bindValue(':' . $key, $value);
            }
            $retorno = $stm->execute();
            return $retorno;
        } catch (\PDOException $e) {
            echo $e->getMessage();
        }
        // try catch trata erros deconhecidos, e permite personalizar os erros ao exibí-los
        $retorno = $stm->execute();
        return $retorno;
    }

    public static function delete($arrayCondicoes)
    {
        try {
            $sql = self::montaSqlDelete($arrayCondicoes);
            $stm = self::$conexao->prepare($sql);

            foreach ($arrayCondicoes as $key => $value) {
                $stm->bindValue(':' . $key, $value);
            }
        } catch (\PDOException $e) {
            echo $e->getMessage();
        }
        $retorno = $stm->execute();
        return $retorno;
    }

    public static function update($arrayDados, $arrayCondicoes)
    {
        try {
            $sql = self::montaSqlUpdate($arrayDados, $arrayCondicoes);
            $stm = self::$conexao->prepare($sql);

            foreach ($arrayDados as $key => $value) {
                $stm->bindValue(':' . $key, $value);
            }

            foreach ($arrayCondicoes as $key => $value) {
                $stm->bindValue(':' . $key, $value);
            }
        } catch (\PDOException $e) {
            echo $e->getMessage();
        }
        $retorno = $stm->execute();
        return $retorno;
    }

    public static function select($sql, $arrayCondicoes, $fetchAll)
    {
        try {
            $stm = self::$conexao->prepare($sql);

            foreach ($arrayCondicoes as $key => $value) {
                $stm->bindValue(':' . $key, $value);
            }

            $stm->execute();

            if ($fetchAll) {
                return $stm->fetchAll(PDO::FETCH_OBJ);
            } else {
                return $stm->fetch(PDO::FETCH_OBJ);
            }
        } catch (\PDOException $e) {
            echo $e->getMessage();
        }
    }
}