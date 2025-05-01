;; TokenStaking: Decentralized Staking and Reward System
;; Version: 1.0.0

(define-data-var treasury-controller principal tx-sender)
(define-data-var staking-pool uint u0)
(define-data-var yield-rate uint u80) ;; yield tokens per block
(define-data-var last-yield-block uint u0) ;; last block when yield was calculated
(define-map staker-balances principal uint)

;; Helper function to ensure only the treasury controller can perform certain actions
(define-private (is-controller (caller principal))
  (begin
    (asserts! (is-eq caller (var-get treasury-controller)) (err u100))
    (ok true)))

;; Initialize the staking system
(define-public (bootstrap (controller principal))
  (begin
    (asserts! (is-none (map-get? staker-balances controller)) (err u101))
    (var-set treasury-controller controller)
    (ok "TokenStaking system bootstrapped")))

;; Stake tokens in the pool
(define-public (stake (amount uint))
  (begin
    (asserts! (> amount u0) (err u102))
    (let ((current-stake (default-to u0 (map-get? staker-balances tx-sender))))
      (map-set staker-balances tx-sender (+ current-stake amount))
      (var-set staking-pool (+ (var-get staking-pool) amount))
      (ok (+ current-stake amount)))))

;; Calculate yield for all stakers
(define-public (calculate-yield)
  (begin
    (try! (is-controller tx-sender))
    (let ((current-block tenure-height)
          (previous-calculation (var-get last-yield-block)))
      (asserts! (> current-block previous-calculation) (err u103))
      ;; Calculate yield based on blocks elapsed
      (let ((elapsed (- current-block previous-calculation))
            (total-yield (* elapsed (var-get yield-rate))))
        (var-set last-yield-block current-block)
        (var-set staking-pool (+ (var-get staking-pool) total-yield))
        (ok total-yield)))))

;; Unstake tokens and claim yield
(define-public (unstake)
  (begin
    (let ((staker-position (default-to u0 (map-get? staker-balances tx-sender))))
      (asserts! (> staker-position u0) (err u104))
      (let ((total-staked (var-get staking-pool))
            (new-yield (* (var-get yield-rate) (- tenure-height (var-get last-yield-block))))
            (stake-ratio (/ (* staker-position u100000) total-staked)))
        ;; Calculate yield based on stake ratio
        (let ((yield-amount (/ (* stake-ratio new-yield) u100000)))
          (map-delete staker-balances tx-sender)
          (var-set staking-pool (- (var-get staking-pool) staker-position))
          (ok (+ staker-position yield-amount)))))))