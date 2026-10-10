/// Why a measurement is invalid; mirrors `GateCheck` plus [interrupted].
enum InvalidReason { sampling, dataGap, tooShort, flatSignal, interrupted }
