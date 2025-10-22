<?php 

require_once 'Conta.php';

class ContaCorrente extends Conta{
    
    #[Override]
    public function Depositar(float $valor): array{

        if($valor <= 0)
            throw new Exception(message: "O valor do depósito deve ser positivo.");
        
        $this->saldo += $valor * 0.99;

        return [
            "tipo" => "deposito",
            "valor_depositado" => $valor,
            "saldo_atual" => $this->saldo,
            "taxa" => $valor * 0.01
        ];
    }

    #[Override]
    public function Sacar(float $valor): array{
        
        if($valor <= 0)
            throw new Exception(message: "O valor do saque deve ser positivo.");
        
        if($valor > $this->saldo)
            throw new Exception(message: "Saldo insuficiente para o saque!");

        $this->saldo -= $valor * 1.01;

        return [
            "tipo" => "saque",
            "valor_sacado" => $valor,
            "saldo_atual" => $this->saldo,
            "taxa" => $valor * 0.01
        ];
    }
}