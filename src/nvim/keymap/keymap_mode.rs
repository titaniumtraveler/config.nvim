use bitflags::bitflags;

bitflags! {
    pub struct Mode: u16 {
        /// CmdLine
        const C    = 1 <<  0;
        /// Insert
        const I    = 1 <<  1;
        /// InsertCmdLine
        const C_I  = 1 <<  2;
        /// Langmap
        const L    = 1 <<  3;
        /// NormalVisualOperator
        const N_VO = 1 <<  4;
        /// Normal
        const N    = 1 <<  5;
        /// OperatorPending
        const O    = 1 <<  6;
        /// Select
        const S    = 1 <<  7;
        /// Terminal
        const T    = 1 <<  8;
        /// Visual
        const X    = 1 <<  9;
        /// VisualSelect
        const V    = 1 << 10;
    }
}

pub mod mode {
    use super::Mode;

    /// CmdLine
    pub const C: Mode = Mode::C;
    /// Insert
    pub const I: Mode = Mode::I;
    /// InsertCmdLine
    pub const C_I: Mode = Mode::C_I;
    /// Langmap
    pub const L: Mode = Mode::L;
    /// NormalVisualOperator
    pub const N_VO: Mode = Mode::N_VO;
    /// Normal
    pub const N: Mode = Mode::N;
    /// OperatorPending
    pub const O: Mode = Mode::O;
    /// Select
    pub const S: Mode = Mode::S;
    /// Terminal
    pub const T: Mode = Mode::T;
    /// Visual
    pub const X: Mode = Mode::X;
    /// VisualSelect
    pub const V: Mode = Mode::V;
}
