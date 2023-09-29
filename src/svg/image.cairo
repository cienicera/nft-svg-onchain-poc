use starknet::ContractAddress;
use alexandria_ascii::ToAsciiTrait;

const WIDTH: u8 = 9;
const HEIGHT: u8 = 7;
const WIDTH_STR: felt252 = '9';
const HEIGHT_STR: felt252 = '7';

fn find_index(value: u8, a: Span<u8>) -> usize {
    let mut i = 0;
    loop {
        if (i >= a.len()) {
            break 0;
        } else if (a.at(i) == @value) {
            break i;
        }
        i += 1;
    }
}

fn get_animation_values(x: u8, y: u8, start: u8) -> (felt252, felt252) {
    let neighbors: Span<u8> = array![0, 3, 6, 7, 8, 5, 2, 1].span();
    let mut i = 0;
    let mut xvalues: felt252 = 0;
    let mut yvalues: felt252 = 0;

    let index = find_index(start, neighbors);
    loop {
        if (i == 9) {
            break (xvalues, yvalues);
        };
        let pos = *neighbors.at((index + i) % neighbors.len());
        let dx: u8 = (pos % 3);
        let dy: u8 = (pos / 3);

        xvalues = xvalues * 256 * 256 + ((x + dx) - 1).to_ascii() * 256 + ';';
        yvalues = yvalues * 256 * 256 + ((y + dy) - 1).to_ascii() * 256 + ';';
        i += 1;
    }
}

use debug::PrintTrait;

fn add_line(ref svg: Array<felt252>, x1: u8, y1: u8, x2: u8, y2: u8) {
    let mut line = ArrayTrait::<felt252>::new();

    let neighbors: Span<u8> = array![0, 3, 6, 7, 8, 5, 2, 1].span();

    let dx = (x2 + 1) - x1;
    let dy = (y2 + 1) - y1;

    let pos = dy * 3 + dx;
    let (xv, yv) = get_animation_values(x1, y1, pos);
    let duration: u8 = 9;

    svg.append('<line x1="');
    svg.append(x1.to_ascii());
    svg.append('" y1="');
    svg.append(y1.to_ascii());
    svg.append('" x2="');
    svg.append(x1.to_ascii());
    svg.append('" y2="');
    svg.append(y1.to_ascii());
    svg.append('" stroke="red" opacity="0.9">');
    svg.append('</line>');

    svg.append('<line x1="');
    svg.append(x1.to_ascii());
    svg.append('" y1="');
    svg.append(y1.to_ascii());
    svg.append('" x2="');
    svg.append(x2.to_ascii());
    svg.append('" y2="');
    svg.append(y2.to_ascii());
    svg.append('" opacity="0.75">');

    svg.append('<animate attributeName="x2"');
    svg.append(' from="');
    svg.append(x2.to_ascii());
    svg.append('" to="');
    svg.append(x2.to_ascii());
    svg.append('" begin=');
    svg.append('"1s" dur="');
    svg.append(duration.to_ascii());
    svg.append('s" values=');
    svg.append('"');
    svg.append(xv);
    svg.append('" keySpline');
    svg.append('s="0.1 0.8 0.2 1;0.1 0.8 0.2');
    svg.append(' 1;0.1 0.8 0.2 1;0.1 0.8 0.2 1;');
    svg.append('0.1 0.8 0.2 1;0.1 0.8 0.2 1;0.1');
    svg.append(' 0.8 0.2 1;0.1 0.8 0.2 1" key');
    svg.append('Times="0;0.125;0.25;0.375;0.5');
    svg.append(';0.625;0.75;0.875;1" calcMode');
    svg.append('="spline" repeatCount="in');
    svg.append('definite"/>');

    svg.append('<animate attributeName="y2"');
    svg.append(' from="');
    svg.append(y2.to_ascii());
    svg.append('" to="');
    svg.append(y2.to_ascii());
    svg.append('" begin=');
    svg.append('"1s" dur="');
    svg.append(duration.to_ascii());
    svg.append('s" values=');
    svg.append('"');
    svg.append(yv);
    svg.append('" keySpline');
    svg.append('s="0.1 0.8 0.2 1;0.1 0.8 0.2');
    svg.append(' 1;0.1 0.8 0.2 1;0.1 0.8 0.2 1;');
    svg.append('0.1 0.8 0.2 1;0.1 0.8 0.2 1;0.1');
    svg.append(' 0.8 0.2 1;0.1 0.8 0.2 1" key');
    svg.append('Times="0;0.125;0.25;0.375;0.5');
    svg.append(';0.625;0.75;0.875;1" calcMode');
    svg.append('="spline" repeatCount="in');
    svg.append('definite"/>');

    svg.append('</line>');
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

fn generate_svg_(token_id: u256) -> Array<felt252> {
    let mut svg = ArrayTrait::new();
    let mut num: u256 = token_id;

    svg.append('<svg xmlns="http://www.w3.org/');
    svg.append('2000/svg" viewBox="-0.2 -0.2');
    svg.append(' ' * 256 + WIDTH_STR);
    svg.append('.4');
    svg.append(' ' * 256 + HEIGHT_STR);
    svg.append('.4" stroke="#1B2D37" stroke');
    svg.append('-width=".4" stroke-linecap="');
    svg.append('round">');

    svg.append('<rect width="');
    svg.append(WIDTH_STR);
    svg.append('" height="');
    svg.append(HEIGHT_STR);
    svg.append('" fill="');
    svg.append(get_bg_color(token_id.high));
    svg.append('" />');

    let mut col = 2_u8;
    loop {
        if (col > WIDTH - 1) {
            break;
        }
        let mut row = 1_u8;
        loop {
            if (row > HEIGHT - 1) {
                break;
            }
            let choice = num % 4;
            num = num / 4;

            if (choice == 0) {
                add_line(ref svg, row - 1, col - 1, row, col);
            };
            if (choice == 1) {
                add_line(ref svg, row, col - 1, row - 1, col);
            };
            if (choice == 2) {
                add_line(ref svg, row, col - 1, row, col);
            };
            if (choice == 3) {
                add_line(ref svg, row, col, row - 1, col);
            };
            add_line(ref svg, col, row, col - 1, row);
            row += 1;
        };
        col += 1;
    };
    svg.append('</svg>');
    svg.append('<!--N1C3R4-L485-->');

    svg
}

fn generate_svg(token_id: u256) -> Array<felt252> {
    let mut svg = ArrayTrait::new();
    let mut num: u256 = token_id;

    svg.append('<svg xmlns="http://www.w3.org/');
    svg.append('2000/svg" viewBox="-0.2 -0.2');
    svg.append(' ' * 256 + WIDTH_STR);
    svg.append('.4');
    svg.append(' ' * 256 + HEIGHT_STR);
    svg.append('.4" stroke="#1B2D37" stroke');
    svg.append('-width=".4" stroke-linecap="');
    svg.append('round">');

    svg.append('<rect width="');
    svg.append(WIDTH_STR);
    svg.append('" height="');
    svg.append(HEIGHT_STR);
    svg.append('" fill="');
    svg.append(get_bg_color(token_id.high));
    svg.append('" />');

    let mut row = 1_u8;
    loop {
        if (row > HEIGHT - 1) {
            break;
        }
        let mut col = 1_u8;
        loop {
            if (col > WIDTH - 1) {
                break;
            }
            let choice = num % 9;
            num = num / 9;

            if choice != 4 {
                let dx: u8 = (choice % 3).try_into().unwrap();
                let dy: u8 = (choice / 3).try_into().unwrap();

                add_line(ref svg, col, row, (col + dx) - 1, (row + dy) - 1);
            }
            col += 1;
        };
        row += 1;
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
        let data = super::generate_svg(30574503567867332939556567041330913640916288);
        print_felt_span(data.span());
    }
}
