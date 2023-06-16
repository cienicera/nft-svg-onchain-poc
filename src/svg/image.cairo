use starknet::ContractAddress;
use array::ArrayTrait;
use integer::{u128_safe_divmod, u128_as_non_zero};
use traits::Into;


fn u8_to_ascii(x: u8) -> felt252 {
    if (x < 10) {
        (x + '0').into()
    } else if (x < 100) {
        x.into() + '00'
    } else {
        x.into() + '000'
    }
}

fn add_line(ref svg: Array<felt252>, x1: u8, y1: u8, x2: u8, y2: u8) {
    let mut line = ArrayTrait::<felt252>::new();
    svg.append('<line x1=\"');
    svg.append(u8_to_ascii(x1));
    svg.append('\" y1=\"');
    svg.append(u8_to_ascii(y1));
    svg.append('\" x2=\"');
    svg.append(u8_to_ascii(x2));
    svg.append('\" y2=\"');
    svg.append(u8_to_ascii(y2));
    svg.append('\"></line>');
}

fn generate_svg(token_id: u256) -> Array<felt252> {
    let mut svg = ArrayTrait::new();
    let mut num: u128 = token_id.low;

    svg.append('<svg xmlns="http://www.w3.org/2');
    svg.append('000/svg" viewBox="-0.2 -0.2 16.');
    svg.append('4 16.4" stroke="#1B2D37" stroke');
    svg.append('-width=".4" stroke-linecap="rou');
    svg.append('nd"');

    let mut row_count = 1_u8;
    loop {
        if (row_count > 9_u8) {
            break;
        }
        let mut col_count = 1_u8;
        loop {
            if (col_count > 7_u8) {
                break;
            }
            let choice = num % 4;
            num = num / 4;
            if num == 0 {
                num = token_id.high
            }
            if (choice == 0) {
                add_line(ref svg, row_count - 1, col_count - 1, row_count, col_count);
            };
            if (choice == 1) {
                add_line(ref svg, row_count, col_count - 1, row_count - 1, col_count);
            };
            if (choice == 2) {
                add_line(ref svg, row_count, col_count - 1, row_count, col_count);
            };
            if (choice == 3) {
                add_line(ref svg, row_count, col_count, row_count - 1, col_count);
            };
            col_count += 1;
        };
        row_count += 1;
    };
    svg.append('</svg>');
    svg.append('<!--N1C3R4-L485-->');
    svg
}
