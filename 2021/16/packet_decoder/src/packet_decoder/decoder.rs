/// Simple packet which represents a node in the packet hierachy
#[derive(Clone, Debug)]
pub struct Packet {
  pub version: u8,
  pub typeid: u8,
  pub sub_packets: Vec<Packet>,
  pub values: u32
}

// impl Packet {
//   /// Create a new packet
//   pub fn new(index: usize, risk: u32) -> Node {
//     Node {
//       version: index,
//       risk: risk,
//       cumulative_risk: u32::MAX
//     }
//   }
// }

/// Decoder at the top of the packet tree
#[derive(Clone, Debug)]
pub struct Decoder {
  pub root: Packet,
}
