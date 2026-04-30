<?php /** @var array $viaggi_autista @var array $viaggi_passeggero */ ?>
<?php $this->layout('layout', ['title' => 'I miei viaggi', 'nav_active' => 'miei']) ?>

<?php $this->start('body') ?>

<section class="section">
  <div class="section-inner">

    <div class="flex-between mb-24">
      <div>
        <h1 style="font-family:var(--serif);font-size:34px;font-weight:600;letter-spacing:-0.8px">I miei viaggi</h1>
        <p style="font-size:15px;color:var(--muted);margin-top:6px">I tuoi viaggi come autista e come passeggero</p>
      </div>
      <a href="<?= $base_path ?>/pubblica" class="btn btn-primary">+ Pubblica viaggio</a>
    </div>

    <?php $tab = $_GET['tab'] ?? 'passeggero'; ?>
    <div class="tabs">
      <a href="?tab=passeggero" class="tab <?= $tab === 'passeggero' ? 'active' : '' ?>">
        Come passeggero (<?= count($viaggi_passeggero) ?>)
      </a>
      <a href="?tab=autista" class="tab <?= $tab === 'autista' ? 'active' : '' ?>">
        Come autista (<?= count($viaggi_autista) ?>)
      </a>
    </div>

    <?php if ($tab === 'passeggero'): ?>

      <?php if (empty($viaggi_passeggero)): ?>
      <div class="empty-state">
        <div class="empty-state-icon">🚗</div>
        <div class="empty-state-title">Nessuna prenotazione</div>
        <p class="empty-state-sub">Non hai ancora prenotato nessun viaggio. Cerca un viaggio e parti!</p>
        <a href="<?= $base_path ?>/cerca" class="btn btn-primary">Cerca un viaggio</a>
      </div>
      <?php else: ?>
      <div class="stack">
        <?php foreach ($viaggi_passeggero as $v): ?>
        <div class="card">
          <div class="card-body">
            <div style="display:grid;grid-template-columns:1fr auto;gap:16px;align-items:start">
              <div>
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">
                  <span class="status-badge status-<?= $v['stato_prenotazione'] ?>"><?= $v['stato_prenotazione'] === 'confermata' ? '✓ Confermata' : ucfirst($v['stato_prenotazione']) ?></span>
                </div>
                <div class="ride-route">
                  <span class="ride-city"><?= $this->e($v['partenza']) ?></span>
                  <span class="ride-arrow">→</span>
                  <span class="ride-city"><?= $this->e($v['arrivo']) ?></span>
                </div>
                <div class="ride-meta mt-8">
                  <span>🗓 <?= date('d M Y', strtotime($v['data_partenza'])) ?></span>
                  <span>🕐 <?= substr($v['ora_partenza'], 0, 5) ?></span>
                  <span>💺 <?= $v['posti_prenotati'] ?> <?= $v['posti_prenotati'] == 1 ? 'posto' : 'posti' ?></span>
                </div>
                <div style="display:flex;align-items:center;gap:8px;margin-top:12px;font-size:13px">
                  <span class="avatar avatar-xs"><?= strtoupper(substr($v['autista_nome'], 0, 1)) ?></span>
                  <span>Autista: <strong><?= $this->e($v['autista_nome']) ?> <?= $this->e($v['autista_cognome'][0]) ?>.</strong></span>
                  <span style="color:var(--accent)">★ <?= number_format($v['voto_medio'], 1) ?></span>
                </div>
              </div>
              <div style="text-align:right">
                <div style="font-family:var(--serif);font-size:24px;font-weight:600;color:var(--brand)"><?= number_format($v['prezzo'], 0) ?>€</div>
                <a href="<?= $base_path ?>/viaggio/<?= $v['id'] ?>" class="btn btn-ghost btn-sm mt-8">Dettagli</a>
              </div>
            </div>
          </div>
        </div>
        <?php endforeach; ?>
      </div>
      <?php endif; ?>

    <?php else: ?>

      <?php if (empty($viaggi_autista)): ?>
      <div class="empty-state">
        <div class="empty-state-icon">📋</div>
        <div class="empty-state-title">Nessun viaggio pubblicato</div>
        <p class="empty-state-sub">Non hai ancora pubblicato nessun viaggio. Inizia a offrire passaggi alla community!</p>
        <a href="<?= $base_path ?>/pubblica" class="btn btn-primary">Pubblica un viaggio</a>
      </div>
      <?php else: ?>
      <div class="stack">
        <?php foreach ($viaggi_autista as $v): ?>
        <div class="card">
          <div class="card-body">
            <div style="display:grid;grid-template-columns:1fr auto;gap:16px;align-items:start">
              <div>
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">
                  <span class="status-badge status-<?= $v['stato'] ?>"><?= ucfirst($v['stato']) ?></span>
                  <?php if ($v['num_prenotazioni'] > 0): ?>
                  <span class="chip chip-brand">👥 <?= $v['num_prenotazioni'] ?> prenotati</span>
                  <?php endif; ?>
                </div>
                <div class="ride-route">
                  <span class="ride-city"><?= $this->e($v['partenza']) ?></span>
                  <span class="ride-arrow">→</span>
                  <span class="ride-city"><?= $this->e($v['arrivo']) ?></span>
                </div>
                <div class="ride-meta mt-8">
                  <span>🗓 <?= date('d M Y', strtotime($v['data_partenza'])) ?></span>
                  <span>🕐 <?= substr($v['ora_partenza'], 0, 5) ?></span>
                  <span>💺 <?= $v['posti_disponibili'] ?>/<?= $v['posti_totali'] ?> posti liberi</span>
                </div>
              </div>
              <div style="text-align:right;display:flex;flex-direction:column;gap:8px">
                <div style="font-family:var(--serif);font-size:24px;font-weight:600;color:var(--brand)"><?= number_format($v['prezzo'], 0) ?>€</div>
                <a href="<?= $base_path ?>/viaggio/<?= $v['id'] ?>" class="btn btn-ghost btn-sm">Dettagli</a>
                <?php if ($v['stato'] === 'attivo'): ?>
                <form action="<?= $base_path ?>/viaggio/<?= $v['id'] ?>/cancella" method="POST" onsubmit="return confirm('Sei sicuro di voler cancellare questo viaggio?')">
                  <button type="submit" class="btn btn-sm" style="background:#fbe5e2;color:#8a2418;border:none;width:100%">Cancella</button>
                </form>
                <?php endif; ?>
              </div>
            </div>
          </div>
        </div>
        <?php endforeach; ?>
      </div>
      <?php endif; ?>

    <?php endif; ?>

  </div>
</section>

<?php $this->stop() ?>
