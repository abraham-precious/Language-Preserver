Language Preserver – NFT Contract for Rare/Indigenous Words

Overview

Language Preserver is a Clarity smart contract designed to protect, celebrate, and immortalize rare or indigenous words by minting them as non-fungible tokens (NFTs) on the blockchain.
Each NFT represents a unique word entry with its meaning, language, and cultural significance — allowing communities and individuals to contribute to the preservation of linguistic heritage.

✨ Key Features

NFT Minting for Words
Mint new NFTs representing unique words from endangered or indigenous languages.

Rich Metadata Storage
Each NFT stores details such as:

Word

Language

Meaning

Cultural Significance

Contributor (wallet address)

Preservation Date (block height)

Community Ownership & Participation

Any address can join the community to participate in collective language preservation.

The design allows for potential governance features (like voting, curation, etc.).

NFT Ownership Transfer
Token holders can transfer ownership securely between principals.

Metadata URI Linking
NFT owners can set an off-chain metadata URI (e.g., IPFS, Arweave) for richer word data such as audio, visuals, or linguistic documentation.

🏗️ Contract Architecture

Constants
Constant	Description
contract-owner	Deployer of the contract
err-owner-only, err-not-found, err-already-exists, err-not-authorized, err-invalid-input	Standardized error codes

Data Variables
Variable	Type	Purpose
next-token-id	uint	Tracks the next NFT ID to be minted
contract-uri	optional (string-ascii 256)	URI for global contract metadata

Data Maps
Map	Key → Value	Description
token-owners	uint → principal	Tracks the owner of each token
token-uris	uint → string-ascii 256	Links token to metadata URI
word-registry	string-ascii 128 → uint	Ensures each word is unique
token-metadata	uint → {word, language, meaning, ...}	Stores detailed word info
community-members	principal → bool	Tracks community participants
token-community-votes	uint → {yes, no}	Placeholder for future voting

⚙️ Public Functions
Function	Description
mint-word(word, language, meaning, cultural-significance)	Mints a new NFT representing a unique word
transfer(token-id, sender, recipient)	Transfers NFT ownership between principals
join-community()	Allows an address to join the preservation community
set-token-uri(token-id, uri)	Sets or updates the metadata URI for a specific NFT

🔍 Read-Only Functions
Function	Description
get-owner(token-id)	Returns the principal owning the NFT
get-word-data(token-id)	Returns metadata about a word NFT
lookup-word(word)	Looks up a token ID by word name
get-token-uri(token-id)	Returns the metadata URI for a token
is-community-member(member)	Checks if an address is part of the community
get-next-token-id()	Returns the next token ID available for minting
get-total-supply()	Returns the total number of NFTs minted

🧠 Example Workflow

Mint a New Word NFT

(contract-call? .language-preserver mint-word 
    "Ubuntu" 
    "Zulu" 
    "A sense of community and humanity" 
    "A core African philosophy reflecting compassion and shared identity")


→ Returns token ID (e.g., u1)

Join the Community

(contract-call? .language-preserver join-community)


Set Metadata URI

(contract-call? .language-preserver set-token-uri u1 "ipfs://QmExampleURI")


Transfer NFT Ownership

(contract-call? .language-preserver transfer u1 tx-sender 'SP2C2...XYZ)


Fetch Word Data

(contract-call? .language-preserver get-word-data u1)

🔒 Error Codes
Code	Description
u100	Owner-only operation attempted by non-owner
u101	Token or record not found
u102	Word already exists in registry
u103	Unauthorized action
u104	Invalid input provided

🌍 Vision
This project aims to digitally preserve languages and empower communities to safeguard cultural identity through blockchain. By turning words into NFTs, the contract ensures that no language is forgotten — every word becomes a permanent, verifiable artifact on-chain.