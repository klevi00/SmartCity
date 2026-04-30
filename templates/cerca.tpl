<?php
/**
 * @var array  $viaggi
 * @var string $partenza
 * @var string $arrivo
 * @var string $data
 * @var int    $posti
 */
?>
<?php $this->layout('layout', ['title' => 'Cerca viaggi', 'nav_active' => 'cerca']) ?>

<?php $this->start('body') ?>

<?php
    $dataLeggibile = ($data !== '') ? date('d M Y', strtotime($data)) : null;
    $haRicercato   = ($partenza !== '' || $arrivo !== '' || $data !== '');
?>

<div style="background:var(--brand);padding:24px 36px">
  <form action="<?= $base_path ?>/cerca" method="GET" class="search-box" style="margin-top:0;max-width:1100px;margin-left:auto;margin-right:auto">
    <div class="search-field">
      <label>Da</label>
      <input type="text" name="da" value="<?= $this->e($partenza) ?>" placeholder="Città di partenza" autocomplete="off">
    </div>
    <div class="search-field">
      <label>A</label>
      <input type="text" name="a" value="<?= $this->e($arrivo) ?>" placeholder="Città di arrivo" autocomplete="off">
    </div>
    <div class="search-field">
      <label>Data</label>
      <input type="date" name="data" value="<?= $this->e($data) ?>" min="<?= date('Y-m-d') ?>">
    </div>
    <div class="search-field">
      <label>Passeggeri</label>
      <select name="posti">
        <?php for ($i = 1; $i <= 4; $i++): ?>
          <option value="<?= $i ?>" <?= $posti == $i ? 'selected' : '' ?>>
            <?= $i ?> <?= $i == 1 ? 'persona' : 'persone' ?>
          </option>
        <?php endfor; ?>
      </select>
    </div>
    <div class="search-field">
      <button type="submit" class="btn btn-accent btn-lg">Aggiorna</button>
    </div>
  </form>
</div>

<section class="section">
  <div class="section-inner">

    <?php if (empty($viaggi)): ?>

      <div class="empty-state">
        <div class="empty-state-icon">😕</div>
        <div class="empty-state-title">Nessun viaggio trovato</div>
        <p class="empty-state-sub">
          <?php if ($partenza !== '' || $arrivo !== ''): ?>
            Nessun viaggio
            <?= $partenza !== '' ? 'da <strong>' . $this->e($partenza) . '</strong>' : '' ?>
            <?= $arrivo   !== '' ? 'a <strong>'  . $this->e($arrivo)   . '</strong>' : '' ?>
            <?= $dataLeggibile !== null ? 'per il ' . $dataLeggibile : '' ?>.
          <?php else: ?>
            Nessun viaggio disponibile<?= $dataLeggibile !== null ? ' per il ' . $dataLeggibile : '' ?>.
          <?php endif; ?>
        </p>
        <a href="<?= $base_path ?>/pubblica" class="btn btn-primary">Pubblica tu un viaggio</a>
      </div>

    <?php else: ?>

      <div class="section-header">
        <div>
          <h2 class="section-title">
            <?php if ($partenza !== '' && $arrivo !== ''): ?>
              <?= $this->e($partenza) ?> → <?= $this->e($arrivo) ?>
            <?php elseif ($partenza !== ''): ?>
              Da <?= $this->e($partenza) ?>
            <?php elseif ($arrivo !== ''): ?>
              A <?= $this->e($arrivo) ?>
            <?php else: ?>
              Tutti i viaggi
            <?php endif; ?>
          </h2>
          <p class="section-sub">
            <?= count($viaggi) ?> <?= count($viaggi) == 1 ? 'viaggio trovato' : 'viaggi trovati' ?>
            <?= $dataLeggibile !== null ? '· ' . $dataLeggibile : '' ?>
          </p>
        </div>
      </div>

      <div class="stack">
        <?php foreach ($viaggi as $v): ?>
          <a href="<?= $base_path ?>/viaggio/<?= $v['id'] ?>" class="ride-card">
            <div>
              <div class="ride-route">
                <span class="ride-city"><?= $this->e($v['partenza']) ?></span>
                <span class="ride-arrow">→</span>
                <span class="ride-city"><?= $this->e($v['arrivo']) ?></span>
              </div>
              <div class="ride-meta">
                <span>📅 <?= date('d M Y', strtotime($v['data_partenza'])) ?></span>
                <span>🕐 <?= substr($v['ora_partenza'], 0, 5) ?></span>
                <span>💺 <?= $v['posti_disponibili'] ?> <?= $v['posti_disponibili'] == 1 ? 'posto' : 'posti' ?> disponibili</span>
                <?php if ($v['no_fumo']): ?>
                  <span class="chip chip-brand" style="font-size:11px">🚭 Non fumatori</span>
                <?php endif; ?>
                <?php if ($v['no_animali']): ?>
                  <span class="chip" style="font-size:11px">🐾 Senza animali</span>
                <?php endif; ?>
                <?php if ($v['solo_donne']): ?>
                  <span class="chip chip-accent" style="font-size:11px">👩 Solo donne</span>
                <?php endif; ?>
              </div>
              <div class="ride-driver">
                <span class="avatar avatar-sm"><?= strtoupper(substr($v['nome'], 0, 1)) ?></span>
                <div>
                  <div class="ride-driver-name"><?= $this->e($v['nome']) ?> <?= $this->e($v['cognome'][0]) ?>.</div>
                  <div class="ride-driver-rating">
                    ★ <?= number_format($v['voto_medio'], 1) ?> (<?= $v['num_recensioni'] ?> recensioni)
                    · <?= $this->e($v['auto_marca']) ?> <?= $this->e($v['auto_modello']) ?> <?= $this->e($v['auto_colore']) ?>
                  </div>
                </div>
              </div>
            </div>
            <div class="ride-price">
              <div>
                <div class="price-val"><?= number_format($v['prezzo'], 0) ?><small>€</small></div>
                <div class="price-seats">a persona</div>
              </div>
              <span class="btn btn-primary" style="margin-top:16px">Prenota →</span>
            </div>
          </a>
        <?php endforeach; ?>
      </div>

    <?php endif; ?>

  </div>
</section>

<?php $this->stop() ?>