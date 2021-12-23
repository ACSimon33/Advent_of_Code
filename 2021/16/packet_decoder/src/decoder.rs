use std::cmp;

// Some message format constants
const PACKET_VERSION: std::ops::Range<usize> = 0..3;
const PACKET_TYPEID: std::ops::Range<usize> = 3..6;
const LENGTH_TYPEID: std::ops::Range<usize> = 6..7;
const PACKET_LENGTH: std::ops::Range<usize> = 7..22;
const PACKET_AMOUNT: std::ops::Range<usize> = 7..18;
const VALUE_LEN: usize = 4;
const LITERAL_TYPE: u8 = 4;

/// Simple packet which represents a node in the packet hierachy
#[derive(Clone, Debug)]
pub struct Packet {
  pub version: u8,
  pub typeid: u8,
  pub sub_packets: Vec<Packet>,
  pub value: u64,
}

impl Packet {
  /// Create a new literal value packet
  pub fn new_value_packet(ver: u8, id: u8, val: u64) -> Packet {
    assert_eq!(id, LITERAL_TYPE);
    Packet {
      version: ver,
      typeid: LITERAL_TYPE,
      sub_packets: Vec::new(),
      value: val,
    }
  }

  /// Create a new operator packet
  pub fn new_operator_packet(ver: u8, id: u8, packets: Vec<Packet>) -> Packet {
    assert_ne!(id, LITERAL_TYPE);
    Packet { version: ver, typeid: id, sub_packets: packets, value: 0 }
  }

  /// Decode a binary string into a package hierachy
  pub fn decode(bin_str: &str) -> (Packet, usize) {
    let ver: u8 = u8::from_str_radix(&bin_str[PACKET_VERSION], 2).unwrap();
    let id: u8 = u8::from_str_radix(&bin_str[PACKET_TYPEID], 2).unwrap();
    let mut idx: usize;

    if id == LITERAL_TYPE {
      idx = 6;
      let mut val_bin: String = String::new();
      let mut last: bool = false;
      while !last {
        last = bin_str.chars().nth(idx).unwrap() == '0';
        idx += 1;
        val_bin += &bin_str[idx..idx + VALUE_LEN];
        idx += VALUE_LEN;
      }
      let val: u64 = u64::from_str_radix(&val_bin, 2).unwrap();
      return (Packet::new_value_packet(ver, id, val), idx);
    } else {
      let mut packets: Vec<Packet> = Vec::new();
      let lid: u8 = u8::from_str_radix(&bin_str[LENGTH_TYPEID], 2).unwrap();
      if lid == 0 {
        let p_len = usize::from_str_radix(&bin_str[PACKET_LENGTH], 2).unwrap();
        idx = 22;
        while idx - 22 < p_len {
          let (p, n) = Packet::decode(&bin_str[idx..]);
          packets.push(p);
          idx += n;
        }
        return (Packet::new_operator_packet(ver, id, packets), idx);
      } else {
        let p_amount = u16::from_str_radix(&bin_str[PACKET_AMOUNT], 2).unwrap();
        idx = 18;
        for _ in 0..p_amount {
          let (p, n) = Packet::decode(&bin_str[idx..]);
          packets.push(p);
          idx += n;
        }
        return (Packet::new_operator_packet(ver, id, packets), idx);
      }
    }
  }

  /// Return the sum of all packet versions
  pub fn version_sum(&self) -> u64 {
    let mut s = self.version as u64;
    for p in self.sub_packets.iter() {
      s += p.version_sum();
    }
    return s;
  }

  /// Evaluate the expression tree
  pub fn evaluate(&self) -> u64 {
    let mut result: u64;
    match self.typeid {
      0 => {
        result = 0;
        for p in self.sub_packets.iter() {
          result += p.evaluate();
        }
      }
      1 => {
        result = 1;
        for p in self.sub_packets.iter() {
          result *= p.evaluate();
        }
      }
      2 => {
        result = u64::MAX;
        for p in self.sub_packets.iter() {
          result = cmp::min(result, p.evaluate());
        }
      }
      3 => {
        result = u64::MIN;
        for p in self.sub_packets.iter() {
          result = cmp::max(result, p.evaluate());
        }
      }
      4 => {
        result = self.value;
      }
      5 => {
        result = (self.sub_packets[0].evaluate()
          > self.sub_packets[1].evaluate()) as u64;
      }
      6 => {
        result = (self.sub_packets[0].evaluate()
          < self.sub_packets[1].evaluate()) as u64;
      }
      7 => {
        result = (self.sub_packets[0].evaluate()
          == self.sub_packets[1].evaluate()) as u64;
      }
      _ => panic!("???"),
    }

    return result;
  }
}

impl From<String> for Packet {
  fn from(bin_str: String) -> Packet {
    Packet::decode(bin_str.as_str()).0
  }
}

/// Decoder at the top of the packet tree
#[derive(Clone, Debug)]
pub struct Decoder {
  pub root: Packet,
}

impl Decoder {
  /// Create a new decoder from a hexadecimal string
  pub fn new(hex_str: &str) -> Decoder {
    let n = hex_str.len();
    let mut bin_str: String = String::new();
    let mut idx: usize = 0;
    while idx < n {
      let num =
        u128::from_str_radix(&hex_str[idx..cmp::min(idx + 32, n)], 16).unwrap();

      let bin_s = format!("{:b}", num);
      bin_str += String::from_utf8(vec![
        b'0';
        cmp::min(4 * (n - idx), 128)
          - bin_s.len()
      ])
      .unwrap()
      .as_str();
      bin_str += bin_s.as_str();
      idx += 32;
    }

    Decoder { root: Packet::from(bin_str) }
  }

  /// Return the sum of all packet versions
  pub fn version_sum(&self) -> u64 {
    return self.root.version_sum();
  }

  /// Evaluate the expression tree
  pub fn evaluate(&self) -> u64 {
    return self.root.evaluate();
  }
}
