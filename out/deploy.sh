export owner_id=ohara38.testnet
export a_id=shib.$owner_id
export b_id=etc.$owner_id
export amm_id=amm2.$owner_id
export sim_id=sim2.$owner_id
export ONE_YOCTO=0.000000000000000000000001
export GAS=55000000000000

#4m
amm_a_balance=400000000000000
#3m
amm_b_balance=300000000000000
#1m
sim_a_balance=100000000000000
#1m
sim_a_exchange=1000000000000

near="near --nodeUrl https://rpc.testnet.near.org"

near delete $a_id $owner_id
near delete $b_id $owner_id
near delete $amm_id $owner_id
near delete $sim_id $owner_id
near create-account $a_id --masterAccount $owner_id --initialBalance 5
near create-account $b_id --masterAccount $owner_id --initialBalance 5
near create-account $amm_id --masterAccount $owner_id --initialBalance 5
near create-account $sim_id --masterAccount $owner_id --initialBalance 5
near deploy --wasmFile out/token_contract.wasm --accountId $a_id 
near deploy --wasmFile out/token_contract.wasm --accountId $b_id 
near deploy --wasmFile out/amm_contract.wasm --accountId $amm_id 



near call $a_id new '{"owner_id":"'$owner_id'", "name":"SHIB Token", "symbol":"SHIB", "total_supply":1000000000000000, "decimals": 8}' --accountId=$owner_id
near call $b_id new '{"owner_id":"'$owner_id'", "name":"ETC Token", "symbol":"ETC", "total_supply":2000000000000000, "decimals": 8}' --accountId=$owner_id
near call $amm_id new '{"owner_id":"'$owner_id'", "a_contract_id":"'$a_id'", "b_contract_id":"'$b_id'"}' --accountId=$owner_id --gas=$GAS

near call $a_id storage_deposit '{"account_id": "'$amm_id'"}' --accountId=$owner_id --deposit=0.1
near call $b_id storage_deposit '{"account_id": "'$amm_id'"}' --accountId=$owner_id --deposit=0.1
near call $a_id storage_deposit '{"account_id": "'$sim_id'"}' --accountId=$owner_id --deposit=0.1
near call $b_id storage_deposit '{"account_id": "'$sim_id'"}' --accountId=$owner_id --deposit=0.1

near call $a_id ft_transfer_call '{"receiver_id": "'$amm_id'","amount":"'$amm_a_balance'","msg":""}' --accountId=$owner_id --deposit=$ONE_YOCTO --gas=$GAS
near call $b_id ft_transfer_call '{"receiver_id": "'$amm_id'","amount":"'$amm_b_balance'","msg":""}' --accountId=$owner_id --deposit=$ONE_YOCTO --gas=$GAS
near call $a_id ft_transfer '{"receiver_id": "'$sim_id'","amount":"'$sim_a_balance'"}' --accountId=$owner_id --deposit=$ONE_YOCTO --gas=$GAS

#100000000000000
near view $a_id ft_balance_of '{"account_id": "'$sim_id'"}'
#0
near view $b_id ft_balance_of '{"account_id": "'$sim_id'"}'
#400000000000000
near view $a_id ft_balance_of '{"account_id": "'$amm_id'"}'
#300000000000000
near view $b_id ft_balance_of '{"account_id": "'$amm_id'"}'


View call: amm2.ohara38.testnet.get_info()
[
  [ 'shib.ohara38.testnet', 'SHIB', 400000000000000, 8 ],
  [ 'etc.ohara38.testnet', 'ETC', 300000000000000, 8 ]
]

near view $amm_id get_info
#12000000000000
near view $amm_id get_ratio

near call $a_id ft_transfer_call '{"receiver_id": "'$amm_id'","amount":"'$sim_a_exchange'","msg":""}' --accountId=$sim_id --deposit=$ONE_YOCTO --gas=$GAS

#100000000000000 - 1000000000000 = 99000000000000
near view $a_id ft_balance_of '{"account_id": "'$sim_id'"}'
#748200000000
near view $b_id ft_balance_of '{"account_id": "'$sim_id'"}'
#400000000000000 + 1000000000000 = 401000000000000
near view $a_id ft_balance_of '{"account_id": "'$amm_id'"}'
#300000000000000 - 748200000000 = 299251800000000
near view $b_id ft_balance_of '{"account_id": "'$amm_id'"}'

[
  [ 'shib.ohara38.testnet', 'SHIB', 401000000000000, 8 ],
  [ 'etc.ohara38.testnet', 'ETC', 299251800000000, 8 ]
]
near view $amm_id get_info
#11999997180000
near view $amm_id get_ratio

near call $a_id ft_transfer_call '{"receiver_id": "'$amm_id'","amount":"'$sim_a_exchange'","msg":""}' --accountId=$sim_id --deposit=$ONE_YOCTO --gas=$GAS
#99000000000000 - 1000000000000 = 98000000000000
near view $a_id ft_balance_of '{"account_id": "'$sim_id'"}'
#748200000000 + 748200000000 = 1496400000000
near view $b_id ft_balance_of '{"account_id": "'$sim_id'"}'
#401000000000000 + 1000000000000 = 402000000000000
near view $a_id ft_balance_of '{"account_id": "'$amm_id'"}'
#299251800000000 - 748200000000 = 298503600000000
near view $b_id ft_balance_of '{"account_id": "'$amm_id'"}'

near view $amm_id get_info

near call $a_id ft_transfer_call '{"receiver_id": "'$amm_id'","amount":"'$sim_a_exchange'","msg":""}' --accountId=$sim_id --deposit=$ONE_YOCTO --gas=$GAS
#98000000000000 - 1000000000000 = 97000000000000
near view $a_id ft_balance_of '{"account_id": "'$sim_id'"}'
#1496400000000 + 748200000000 = 2244600000000
near view $b_id ft_balance_of '{"account_id": "'$sim_id'"}'
#402000000000000 + 1000000000000 = 403000000000000
near view $a_id ft_balance_of '{"account_id": "'$amm_id'"}'
#298503600000000 - 748200000000 = 297755400000000
near view $b_id ft_balance_of '{"account_id": "'$amm_id'"}'

[
  [ 'shib.ohara38.testnet', 'SHIB', 403000000000000, 8 ],
  [ 'etc.ohara38.testnet', 'ETC', 297766500000000, 8 ]
]
near view $amm_id get_info