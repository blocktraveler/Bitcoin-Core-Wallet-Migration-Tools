

 #                      Bitcoin Core Wallet Migration Tools

 #            Website: www.namecoin.pro | Web3 ID: https://dotbit.app


---

##  Overview
  
---

  These wallet migration tools for Windows DOS Batch facilitate the migration of 
  private keys from legacy Berkeley DB (BDB) wallets to modern descriptor wallets 
  in Bitcoin Core. Place the tools in the folder:

      C:\Program Files\Bitcoin\daemon

  On-chain archive:
  -----------------
  [nft/Bitcoin_Core_wallet_migration.zip](https://namecoin.online/explorer/details.php?q=nft%2FBitcoin_Core_wallet_migration.zip)

  Included Scripts:
  -----------------
  1. Dump_privkeys.bat  - Export private keys of UTXOs.
  2. Import_descriptors.bat  - Import private keys into descriptor wallets.

---

##  Dump_privkeys.bat
  
---

  This Windows batch script automates the extraction of private keys for
  unspent Transaction Outputs (UTXOs) using the 'listunspent' RPC command.

  Prerequisites:
  --------------
  - Ensure the wallet is unlocked if encrypted.
  - Wait until all your wallet transactions have at least one confirmation to include all UTXOs.
  - The script assumes you are using a legacy Berkeley DB (BDB) wallet in Bitcoin Core.
  - Make sure Bitcoin Core is running and the RPC access is properly configured.

  Notes:
  ------
  - The extracted private keys should be handled with extreme caution.
    Never share or expose them, as they grant access to your funds and assets!
  - This script does not modify wallet data; it only exports private keys for 
    backup and migration purposes.

  Output:
  -------
  - Private keys for names and UTXOs will be stored line by line in the 'privkeys.txt'. 
  - Rename or backup previous 'privkeys.txt' files.

---

##  Import_descriptors.bat
  
---

  This Windows batch script automates the process of importing private keys from 
  legacy Berkeley DB (BDB) wallets in Bitcoin Core (stored line by line in the 
  'privkeys.txt') into modern descriptor wallets in Bitcoin Core.

  Supported Key Types:
  ---------------------
  1. Bech32/SegWit Single-Key Private Keys:
     - Use the default descriptor 'wpkh(%%k)' (Witness Public Key Hash) for importing 
       single-key Bech32/SegWit addresses (starting with 'bc1...').

  2. Base58Check Legacy Single-Key Private Keys:
     - For private keys from single-key legacy addresses (Base58Check encoded), 
       modify the descriptor to 'pkh(%%k)' (Public Key Hash) at lines 56, 69, and 76.

  Additional Notes:
  -----------------
  - Private keys must be exported from BDB wallets in Bitcoin Core using 
    'Dump_privkeys.bat' or via the RPC command 'dumpprivkey'.
  - Ensure the wallet is unlocked if encrypted.
  - All descriptors are imported in batches of 10 descriptors, otherwise larger 
    wallets might exceed the maximum command size in DOS.
  - Wait at least 15 blocks (two hours) after your last wallet transactions to avoid 
    a rescan of the most recent transactions during each batch import.
  - A full blockchain rescan is initiated on the last import. Depending on the size 
    of your wallet, this may cause a timeout error on the last import, which can 
    be ignored as it won't affect a successful import.
  - For multi-signature addresses (both legacy and Bech32), modifications to the 
    script are required.

---

  IMPORTANT: Handle all private keys and descriptors with caution! Mishandling them 
  may result in the loss of funds or assets. Use these tools responsibly.
  
---

  DISCLAIMER: These scripts are provided "as is" without warranty of any kind,
  either expressed or implied. The author disclaims any responsibility or liability
  for any loss of funds, assets or data, or for any damage resulting
  from its use or misuse!
  
---

