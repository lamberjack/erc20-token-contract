/**
 *Submitted for verification at BscScan.com on 2021-05-17
*/

pragma solidity ^0.8.2;

/**
 *
 * Dichiarazione dello smart contract dello spam token
 * 
 **/
contract Spam{
    
    /**
     * Metadata del token: descrivono le sue caratteristiche principali.
     * Nome, simbolo, e fornitura totale. In particolare quest'ultima è di
     * 30000 unità * 10^18 (dato che il token è frazionabile fino a 18 decimali)
     * 
    **/
    uint public totalSupply = 30000 * 10 ** 18;
    string public name = "Spam";
    string public symbol ="SPM";
    uint public decimals = 18;
    
    /**
     * Strutture dati necessarie per mappare gli address con i relativi numeri di token associati.
     * Si tratta di mappe key-value.
     * **/
     
    // Mappa che si viene utilizzata per il mapping di un indirizzo (address) con il numero di token detenuti
    mapping(address => uint) public balances;
    
    // Mappa gli indirizzi con una struttura annidata: key - map( key - value )
    // L'indirizzo più esterno è il proprietario del token che può
    //avere associati molteplici 'spender' che hanno associato un certo valore di token che spendono
    mapping(address => mapping(address => uint)) public allowance;
    
    
    /**
     * Eventi associati allo smart contract ed emessi dalle sue funzioni.
     * Uno smart contract può emettere eventi, ma non può leggere gli eventi che ha emesso in passato.
     * Gli eventi sono emessi durante l'esecuzione dallo smart contract e sono ricevuti e letti
     * al di fuori dello smart contract: ad esempio da wallets e software esterno.
     * **/
    
    // evento di trasferimento emesso dalla funzione transfer(). I parametri indexed verranno loggati (indexed)
    event Transfer(address indexed from, address indexed recipient, uint value);
    
    // evento di approvazione viene emesso dalla funzione approve().
    event Approval(address indexed owner, address indexed spender, uint value); 
    
    /**
     * Costruttore dello smart contract, viene eseguito soltanto una volta
     * quando lo smart contract relativo è deployato sulla blockchain
     * **/
    constructor(){
        // Invia tutta la supply del token all'address che deploya lo smart contract.
        // Viene utilizzata l'address (msg.sender) che invia la transazione di 
        // deploy dello smart contract e che quindi riceve tutta la supply
        balances[msg.sender] = totalSupply;
    }
    
    /**
     * 
     * Restituisce il numero di token posseduti dall'address passato come argomento.
     * La funzione è 'public' poichè può essere invocata anche da fuori dallo smart contract.
     * La funzione è readonly e quindi è annotata con la keyword 'view'.
     * Il tipo di valore restituito è indicato grazie alle keyword 'returns' 
     * con il tipo al suo interno.
     * 
     * **/
    function balanceOf(address owner) public view returns(uint){
        // utilizza il mapping balances passandogli l'indirizzo di cui
        // si vuole sapere il numero di token.
        return balances[owner];
    }
    
    /**
     * Funzione utilizzata per trasferire un certo ammontare di token 
     * (1 * 10^18) anche frazionato all'indirizzo passato.
     * il nome di questa funzione (transfer) deve essere questo per essere 
     * coerenti con lo standard BEP-20.
     * Non è una funzione readonly (modifica dei dati sulla blockchain)
     * e quindi non ha la keyword 'view'.
     * **/
    function transfer(address to, uint value)public returns(bool){
        //costrutto 'require' di solidity che verifica che la condizione presente sia verificata
        // per continuare l'esecuzione; altrimenti viene visualizzato un errore e la transazione è abortita.
        // in questo caso verifica che il numero di token del sender (msg.sender -> chiamante della funzione)
        // della transazione, sia maggiore del numero di token che si vuole trasferire.
        require(balanceOf(msg.sender) >= value,'balance of the sender is too low' );
        
        // se il controllo viene passato viene effettuato il trasferimento.
        // aggiorna il bilancio dell'address a cui sono indirizzati i token.
        balances[to] += value;
        
        // aggiorna il bilancio dell'address che ha inviato i token.
        balances[msg.sender] -= value;
        
        // viene emesso l'evento del trasferimento del valore
        emit Transfer(msg.sender, to, value);
        return true;
        
    }
    
    /**
     * Funzione di trasferimento da un address (from) ad un altro address (to) di
     * un certo quantitativo di token.
     * **/
    function transferFrom(address from, address to, uint value)public returns(bool){
        
        // verifica che il mandante abbia abbastanza token per effettuare il versamento
        require(balanceOf(from) >= value, 'balance of the from address is too low');
        
        // verifica che l'indennità del committente della transazione sia sufficiente
        require(allowance[from][msg.sender] >= value, 'allowance is too low');
        
        // aggiornamento dei valori degli address del mandante e del ricevente.
        balances[to] += value;
        balances[from] -= value;
        
        // emissione dell'evento del trasferimento del valore
        emit Transfer(from, to, value);
        return true;
        
    }
    
    /**
     * Funzione per approvare la spesa dell'indirizzo dello spender passato, dei token appartenenti
     * al committente della transazione (il chiamante della funzione).
     * **/
    function approve(address spender, uint value) public returns(bool){
        allowance[msg.sender][spender] = value;
        
        // emissione del relativo evento di approvazione del value.
        emit Approval(msg.sender, spender, value);
        return true;
        
    }
    
    
}