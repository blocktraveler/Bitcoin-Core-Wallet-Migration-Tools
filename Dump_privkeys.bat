::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Copyright (C) 2024 by Uwe Martens * www.namecoin.pro  * https://dotbit.app

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Batch Script for Exporting Private Keys of UTXOs from Legacy BDB Wallets in Bitcoin Core
:: ----------------------------------------------------------------------------------------------------
:: This Windows batch script automates the extraction of private keys for
:: unspent Transaction Outputs (UTXOs) using the 'listunspent' RPC command.
::
:: Prerequisites:
:: --------------
:: - Ensure the wallet is unlocked if encrypted.
:: - Wait until all your wallet transactions have at least one confirmation to include all UTXOs.
:: - The script assumes you are using a legacy Berkeley DB (BDB) wallet in Bitcoin Core.
:: - Make sure Bitcoin Core is running and the RPC access is properly configured.
::
:: Notes:
:: ------
:: - The extracted private keys should be handled with extreme caution.
::   Never share or expose them, as they grant access to your funds and assets!
:: - This script does not modify wallet data; it only exports private keys for backup and migration purposes.
::
:: Output:
:: -------
:: - Private keys will be stored line by line in the 'privkeys.txt'.
:: - Rename or backup previous 'privkeys.txt' files.

:: DISCLAIMER:
:: ------------------
:: This script is provided "as is" without warranty of any kind, either expressed or implied. The author
:: disclaims any responsibility or liability for any loss of funds, assets or data, or for any damage
:: resulting from its use or misuse!

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


@echo off
setlocal enabledelayedexpansion

set /a count=0
for /f "tokens=2" %%i in ('bitcoin-cli listunspent ^| findstr /c:"address"') DO (
	set /a count+=1

	set address_utxo=%%i

	call set address_utxo=!address_utxo:"=!
	call set address_utxo=!address_utxo: =!
	call set address_utxo=!address_utxo:,=!

	for /f %%k in ('bitcoin-cli dumpprivkey !address_utxo!') DO (
		set privkey=%%k
		echo !privkey!
		echo !privkey!>>privkeys.txt
	)
)

echo:
echo Number of UTXOs: %count%
echo:
echo:

endlocal
pause
