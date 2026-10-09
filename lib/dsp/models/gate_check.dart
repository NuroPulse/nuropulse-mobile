/// Quality-gate checks. Movement, clipping, and noise-floor checks are not
/// implemented yet because their thresholds are still null in dsp_config.json.
enum GateCheck { sampling, dataGap, flatSignal }
