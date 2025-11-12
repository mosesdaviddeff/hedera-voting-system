import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:json_rpc_2/json_rpc_2.dart' as rpc;

class HederaService {
  late Web3Client _web3client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;
  late EthereumAddress _contractAddress;

  // The ABI from your Hardhat project: hedera-voting-system-main/artifacts/contracts/Voting.sol/Voting.json
  final String _contractAbi = """
  [
    {
      "inputs": [],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "uint256",
          "name": "_candidateId",
          "type": "uint256"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "_voter",
          "type": "address"
        }
      ],
      "name": "Voted",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "name": "candidates",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "id",
          "type": "uint256"
        },
        {
          "internalType": "string",
          "name": "name",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "voteCount",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "candidatesCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "name": "hasVoted",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "_candidateId",
          "type": "uint256"
        }
      ],
      "name": "vote",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
  """;

  HederaService({required String privateKey}) {
    final rpcUrl = dotenv.env['HEDERA_TESTNET_RPC_URL']!;
    _web3client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);

    _contractAddress =
        EthereumAddress.fromHex(dotenv.env['VOTING_CONTRACT_ADDRESS']!);

    _contract = DeployedContract(
      ContractAbi.fromJson(_contractAbi, 'Voting'),
      _contractAddress,
    );
  }

  /// Calls the 'vote' function on the smart contract.
  Future<String> vote(int candidateId) async {
    try {
      final voteFunction = _contract.function('vote');
      final transaction = Transaction.callContract(
        contract: _contract,
        function: voteFunction,
        parameters: [BigInt.from(candidateId)],
      );

      final txHash = await _web3client.sendTransaction(
        _credentials,
        transaction,
        chainId: 296, // Hedera Testnet Chain ID
      );

      print("Vote transaction hash: $txHash");
      return "Vote cast successfully! Transaction hash: $txHash";
    } on rpc.RpcException catch (e) {
      // Handle specific contract revert errors
      if (e.message.contains("Error: You have already voted.")) {
        return "You have already cast your vote.";
      }
      print("An RPC error occurred: ${e.message}");
      return "An error occurred: ${e.message}";
    } catch (e) {
      print("An unknown error occurred: $e");
      return "An unknown error occurred.";
    }
  }
}