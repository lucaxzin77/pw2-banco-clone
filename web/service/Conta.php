<?php 

abstract class Conta{
    protected int $id;
    protected Titular $titular;
    protected float $saldo;
    protected float $limite;

    public function setId(int $id):void{
        if($id <= 0){
            throw new Exception(message: "O numero da conta deve ser positivo!");
        }
        $this->id = $id;
    }

    public function getId():int{
        return $this->id;
    }

    public function setTitular(Titular $titular):void{
        $this->titular = $titular;
    }

    public function getTitular():Titular{
        return $this->titular;
    }

    public function getSaldo():float{
        return $this->saldo;
    }

    public function setLimite(float $limite):void{
        $this->limite = $limite;
    }

    public function getLimite():float{
        return $this->limite;
    }

    abstract public function Depositar(float $valor): array;

    abstract public function Sacar(float $valor): array;

    public function Transferir(Conta $contaDestino, float $valor): array{
        if($contaDestino == null){
            throw new ArgumentException(message: "A conta de destino não pode ser nula!");
        }

        $resultado = [];

        $resultado['saque'] = $this->Sacar($valor);
        $resultado['saque'] = $contaDestino->Depositar($valor);
    }
}
