use starknet::ContractAddress;

#[starknet::interface]
trait IERC721<TContractState> {
    // Views
    fn name(self: @TContractState) -> felt252;
    fn symbol(self: @TContractState) -> felt252;
    fn owner(self: @TContractState) -> ContractAddress;
    fn token_uri(self: @TContractState, token_id: u256) -> Array<felt252>;
    fn balance_of(self: @TContractState, owner: ContractAddress) -> u256;
    fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
    fn get_approved(self: @TContractState, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(
        self: @TContractState, owner: ContractAddress, operator: ContractAddress
    ) -> bool;
    fn transfer_from(
        self: @TContractState, from: ContractAddress, to: ContractAddress, token_id: u256
    );

    // Externals
    fn approve(ref self: TContractState, approved: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: TContractState, operator: ContractAddress, approval: bool);
    fn mint(ref self: TContractState, to: ContractAddress);
}
