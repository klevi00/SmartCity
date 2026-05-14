<?php /** @var array $viaggi_recenti @var string $base_path */ ?>
<?php $this->layout('layout', ['title' => 'Carpooling in Italia', 'nav_active' => 'home']) ?>

<?php $this->start('body') ?>

<section class="hero">
  <div class="hero-inner">
    <h1 class="hero-title">
      Viaggia in compagnia,<br>
      <em>spendi di meno.</em>
    </h1>
    <p class="hero-sub">
      Risparmia, conosci persone, inquina meno.
    </p>

    <form action="<?= $base_path ?>/cerca" method="GET" class="search-box">
      <div class="search-field">
        <label>Da</label>
        <input type="text" name="da" placeholder="Città di partenza" autocomplete="off">
      </div>
      <div class="search-field">
        <label>A</label>
        <input type="text" name="a" placeholder="Città di arrivo" autocomplete="off">
      </div>
      <div class="search-field">
        <label>Data</label>
        <input type="date" name="data" value="<?= date('Y-m-d') ?>" min="<?= date('Y-m-d') ?>">
      </div>
      <div class="search-field">
        <label>Passeggeri</label>
        <select name="posti">
          <option value="1">1 persona</option>
          <option value="2">2 persone</option>
          <option value="3">3 persone</option>
          <option value="4">4 persone</option>
        </select>
      </div>
      <div class="search-field">
        <button type="submit" class="btn btn-accent btn-lg">Cerca</button>
      </div>
    </form>
  </div>
</section>

<?php if (!empty($viaggi_recenti)): ?>
<section class="section">
  <div class="section-inner">
    <div class="section-header">
      <div>
        <h2 class="section-title">Viaggi disponibili</h2>
        <p class="section-sub">I prossimi viaggi pubblicati dalla community</p>
      </div>
      <a href="<?= $base_path ?>/cerca" class="btn btn-ghost">Vedi tutti →</a>
    </div>
    <div class="grid-cards">
      <?php foreach ($viaggi_recenti as $v): ?>
      <a href="<?= $base_path ?>/viaggio/<?= $v['id'] ?>" class="ride-card">
        <div>
          <div class="ride-route">
            <span class="ride-city"><?= $this->e($v['partenza']) ?></span>
            <span class="ride-arrow">→</span>
            <span class="ride-city"><?= $this->e($v['arrivo']) ?></span>
          </div>
          <div class="ride-meta">
            <span>🗓 <?= date('d M', strtotime($v['data_partenza'])) ?></span>
            <span>🕐 <?= substr($v['ora_partenza'], 0, 5) ?></span>
            <span>💺 <?= $v['posti_disponibili'] ?> <?= $v['posti_disponibili'] == 1 ? 'posto' : 'posti' ?></span>
            <?php if ($v['no_fumo']): ?><span>🚭</span><?php endif; ?>
          </div>
          <div class="ride-driver">
            <span class="avatar avatar-sm"><?= strtoupper(substr($v['nome'], 0, 1)) ?></span>
            <div>
              <div class="ride-driver-name"><?= $this->e($v['nome']) ?> <?= $this->e($v['cognome'][0]) ?>.</div>
              <div class="ride-driver-rating">★ <?= number_format($v['voto_medio'], 1) ?> · <?= $this->e($v['auto_marca']) ?> <?= $this->e($v['auto_modello']) ?></div>
            </div>
          </div>
        </div>
        <div class="ride-price">
          <div>
            <div class="price-val"><?= number_format($v['prezzo'], 0) ?><small>€</small></div>
            <div class="price-seats">a persona</div>
          </div>
          <span class="btn btn-primary btn-sm" style="margin-top:12px">Vedi →</span>
        </div>
      </a>
      <?php endforeach; ?>
    </div>
  </div>
</section>
<?php endif; ?>

<section class="section" style="background:var(--paper);border-top:1px solid var(--line)">
  <div class="section-inner">
    <div style="text-align:center;margin-bottom:40px">
      <h2 class="section-title">Come funziona</h2>
      <p class="section-sub">Tre passi per iniziare a viaggiare con Tragitto</p>
    </div>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:32px">
      <?php foreach ([
        ['🔍', 'Cerca un viaggio', 'Inserisci partenza, destinazione e data. Trova l\'autista giusto per te tra centinaia di offerte.'],
        ['📋', 'Prenota il tuo posto', 'Scegli il viaggio che fa per te e prenota in pochi clic. Conferma immediata.'],
        ['🚗', 'Viaggia insieme', 'Incontra il tuo autista al punto di ritrovo e goditi il viaggio in compagnia.'],
      ] as [$icon, $title, $desc]): ?>
      <div style="text-align:center;padding:20px">
        <div style="font-size:40px;margin-bottom:16px"><?= $icon ?></div>
        <h3 style="font-family:var(--serif);font-size:20px;font-weight:600;margin-bottom:10px"><?= $title ?></h3>
        <p style="font-size:14px;color:var(--muted);line-height:1.65"><?= $desc ?></p>
      </div>
      <?php endforeach; ?>
    </div>
    <div style="text-align:center;margin-top:36px;display:flex;gap:14px;justify-content:center">
      <a href="<?= $base_path ?>/cerca" class="btn btn-primary btn-lg">Cerca un viaggio</a>
      <a href="<?= $base_path ?>/pubblica" class="btn btn-ghost btn-lg">Pubblica il tuo</a>
    </div>
  </div>
</section>

<?php $this->stop() ?>
