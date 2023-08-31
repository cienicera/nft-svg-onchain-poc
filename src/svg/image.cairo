use starknet::ContractAddress;
use alexandria_ascii::ToAsciiTrait;

const WIDTH: u8 = 9;
const HEIGHT: u8 = 7;
const WIDTH_STR: felt252 = '9';
const HEIGHT_STR: felt252 = '7';


fn add_line(ref svg: Array<felt252>, x1: u8, y1: u8, x2: u8, y2: u8) {
    let mut line = ArrayTrait::<felt252>::new();
    svg.append('<line x1=\"');
    svg.append(x1.to_ascii());
    svg.append('\" y1=\"');
    svg.append(y1.to_ascii());
    svg.append('\" x2=\"');
    svg.append(x2.to_ascii());
    svg.append('\" y2=\"');
    svg.append(y2.to_ascii());
    svg.append('\"></line>');
}

fn get_hex_letter(n: u128) -> felt252 {
    if n > 15 {
        return 'F';
    }
    let hex = array!['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F']
        .span();
    return *hex.get(n.try_into().unwrap()).unwrap().unbox();
}

fn get_bg_color(rand: u128) -> felt252 {
    let mut seed = rand;
    let b = 10 + seed % 6;
    seed /= 16;
    let a = seed % 16;
    seed /= 16;
    let c = seed % 16;
    let red = get_hex_letter(a);
    let green = get_hex_letter(b);
    let blue = get_hex_letter(c);
    return (('#' * 0x1_00 + red) * 0x1_00 + green) * 0x1_00 + blue;
}

fn generate_svg(token_id: u256) -> Array<felt252> {
    let mut svg = ArrayTrait::new();
    let mut num: u256 = token_id;

    svg.append('<svg xmlns=\\"http://www.w3.org/');
    svg.append('2000/svg\\" viewBox=\\"-0.2 -0.2 ');
    svg.append(WIDTH_STR);
    svg.append('.4 ');
    svg.append(HEIGHT_STR);
    svg.append('.4\\" stroke=\\"#1B2D37\\" stroke');
    svg.append('-width=\\".4\\" stroke-linecap=\\"');
    svg.append('round\\">');

    svg.append('<rect width=\\"');
    svg.append(WIDTH_STR);
    svg.append('\\" height=\\"');
    svg.append(HEIGHT_STR);
    svg.append('\\" fill=\\"');
    svg.append(get_bg_color(token_id.high));
    svg.append('\\" />');

    let mut row_count = 1_u8;
    loop {
        if (row_count > WIDTH) {
            break;
        }
        let mut col_count = 1_u8;
        loop {
            if (col_count > HEIGHT) {
                break;
            }
            let choice = num % 4;
            num = num / 4;

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

#[cfg(test)]
mod Test {
    use array::SpanTrait;
    use debug::PrintTrait;

    fn print_felt_span(a: Span<felt252>) {
        let mut a = a;
        match a.pop_front() {
            Option::Some(value) => {
                (*value).print();
                print_felt_span(a);
            },
            Option::None(()) => {}
        }
    }

    #[test]
    #[available_gas(914200000)]
    fn test_generate() {
        let data = super::generate_svg('NICERALABSPOC___0123456789ABCDEF');
        print_felt_span(data.span());
    }
}
