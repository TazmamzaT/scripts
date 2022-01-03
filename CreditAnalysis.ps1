#Transaction Date,Posted Date,Card No.,Description,Category,Debit,Credit
#I'm sorry these variable names suck I suck. Obvs the original file isn't in the repo but the columns are above
$transactionsraw = [Transaction[]]@()
$csvtransactions = Import-Csv -Path .\2021CreditStatement.csv

foreach($transactioncsv in $csvtransactions)
{
    $transactionsraw += $transactioncsv
}

$consolidatedtransactions = [TransactionConcise]@{}

foreach($transaction in $transactionsraw)
{
    $consolidatedtransactions += @{Descrption = $transaction.Description; Debit = $transaction.Debit}
}


class Transaction
{
    [datetime]$TransactionDate
    [datetime]$PostedDate
    [string]$CardNo
    [string]$Description
    [string]$Category
    [double]$Debit
    [double]$Credit
}

class TransactionConcise
{
    [string]$Description
    [double]$Debit

    
}