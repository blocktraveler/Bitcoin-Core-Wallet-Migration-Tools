::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Copyright (C) 2024 by Uwe Martens * www.namecoin.pro  * https://dotbit.app

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: DOS Batch Script for Importing Private Keys into Descriptor Wallets
:: --------------------------------------------------------------------
:: This Windows batch script automates the process of importing private keys
:: from legacy Berkeley DB (BDB) wallets in Bitcoin Core (stored line by line in the 'privkeys.txt')
:: into modern Descriptor wallets in Bitcoin Core

:: Supported Key Types:
:: ---------------------
:: 1. Bech32/SegWit Single-Key Private Keys:
::	- Use the default descriptor 'wpkh(%%k)' (Witness Public Key Hash) for importing 
::	  single-key Bech32/SegWit addresses (starting with 'nc1...').

:: 2. Base58Check Legacy Single-Key Private Keys:
::	- For private keys from single-key legacy addresses (Base58Check encoded), 
::	  modify the descriptor to 'pkh(%%k)' (Public Key Hash) at lines 62, 75, and 82.

:: Additional Notes:
:: ------------------
:: - Private keys must be exported from BDB wallets in Bitcoin Core using 'Dump_privkeys.bat' or via the
::   RPC command 'dumpprivkey'.
:: - Ensure the wallet is unlocked if encrypted.
:: - All descriptors are imported in batches of 10 descriptors, otherwise larger wallets might exceed the
::   maximum command size in DOS.
:: - Make sure to wait at least 15 blocks (two hours) with the import after your last wallet transactions
::   to avoid a rescan of the most recent transactions after each batch import.
:: - A full blockchain rescan is initiated on the last import. Depending on the size of your wallet, this may
::   cause a timeout error on the last import, which can be ignored as it won't effect a sucessfull import.
:: - For multi-signature addresses (both legacy and Bech32), modifications to the script are required.

:: DISCLAIMER:
:: ------------------
:: This script is provided "as is" without warranty of any kind, either expressed or implied. The author
:: disclaims any responsibility or liability for any loss of funds, assets or data, or for any damage
:: resulting from its use or misuse!

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


@echo off
setlocal enabledelayedexpansion

set /a lines=0
for /f %%x in (privkeys.txt) do (
	set /a lines+=1
)

set /a line_counter=0
set /a batch_counter=0
for /f "delims=" %%k in (privkeys.txt) do (

	set PRIVATE_KEY=%%k
	set /a line_counter+=1
	echo:
	echo !line_counter!/!lines!

	for /f "tokens=2" %%a in ('bitcoin-cli getdescriptorinfo "wpkh(%%k)" ^| findstr /c:"checksum"') do (
		set CHECKSUM=%%a
	)
	set CHECKSUM=!CHECKSUM:"=!
	set CHECKSUM=!CHECKSUM:,=!

	if !batch_counter! EQU 0 (
		set BATCH_IMPORT=[
	) else (
		set BATCH_IMPORT=!BATCH_IMPORT!,
	)

	if !line_counter! LSS !lines! (
		set BATCH_IMPORT=!BATCH_IMPORT!{\"desc\":\"wpkh(%%k)#!CHECKSUM!\",\"timestamp\":\"now\"}
		set /a batch_counter+=1
		if !batch_counter! EQU 10 (
			bitcoin-cli importdescriptors !BATCH_IMPORT!]
			set /a batch_counter=0
		)
	) else (
		bitcoin-cli importdescriptors !BATCH_IMPORT!{\"desc\":\"wpkh(%%k)#!CHECKSUM!\",\"timestamp\":0}]
	)
)

echo:
echo [INFO] All private keys imported successfully.
echo:
echo:
endlocal
pause
