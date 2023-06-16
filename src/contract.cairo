#[starknet::contract]
mod SvgPoc {
    use nft_svg_onchain_poc::interfaces::erc721::IERC721;
    use nft_svg_onchain_poc::svg::image::generate_svg;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use zeroable::Zeroable;
    use option::OptionTrait;
    use array::ArrayTrait;
    use traits::Into;

    const IERC721_ID: felt252 = 0x80ac58cd;
    const IERC721_METADATA_ID: felt252 = 0x5b5e139f;
    const IERC721_RECEIVER_ID: felt252 = 0x150b7a02;

    #[storage]
    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _owners: LegacyMap<u256, ContractAddress>,
        _balances: LegacyMap<ContractAddress, u256>,
        _token_approvals: LegacyMap<u256, ContractAddress>,
        _operator_approvals: LegacyMap<(ContractAddress, ContractAddress), bool>,
        _token_uri: LegacyMap<u256, felt252>,
        _owner: ContractAddress,
    }

    // Events
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
        ApprovalForAll: ApprovalForAll,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: ContractAddress,
        approved: ContractAddress,
        token_id: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        owner: ContractAddress,
        operator: ContractAddress,
        approved: bool,
    }

    #[constructor]
    fn constructor(ref self: ContractState, name_: felt252, symbol_: felt252) {
        self._name.write(name_);
        self._symbol.write(symbol_);
        self._owner.write(get_caller_address());
    }

    #[external(v0)]
    impl SvgPoc of IERC721<ContractState> {
        fn name(self: @ContractState) -> felt252 {
            'nicera_svg_poc'
        }

        fn symbol(self: @ContractState) -> felt252 {
            'NSP'
        }

        fn owner(self: @ContractState) -> ContractAddress {
            self._owner.read()
        }

        fn token_uri(self: @ContractState, token_id: u256) -> Array<felt252> {
            generate_svg(token_id)
        }

        fn balance_of(self: @ContractState, owner: ContractAddress) -> u256 {
            1
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self._owner.read()
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            self._owner.read()
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            false
        }

        fn transfer_from(
            self: @ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {}

        // Externals
        fn approve(ref self: ContractState, approved: ContractAddress, token_id: u256) {}
        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approval: bool
        ) {}

        fn mint(ref self: ContractState, to: ContractAddress) {
            assert(!to.is_zero(), 'ERC721: invalid receiver');
            let token_id: felt252 = get_caller_address().into();
            let token_id: u256 = token_id.into();
            assert(!self._exists(token_id), 'ERC721: token already minted');

            // Update balances
            self._balances.write(to, self._balances.read(to) + 1.into());

            // Update token_id owner

            self._owners.write(token_id, to);

            // Emit event
            self.emit(Event::Transfer(Transfer { from: Zeroable::zero(), to, token_id }));
        }
    }

    /// Helpers (internal functions)
    #[generate_trait]
    impl HelperImpl of HelperTrait {
        fn _exists(self: @ContractState, token_id: u256) -> bool {
            !self._owners.read(token_id).is_zero()
        }
    }
}
