<?php /** @var array $viaggio @var bool $gia_prenotato @var array $passeggeri */ ?>
<?php $this->layout('layout', ['title' => $viaggio['partenza'].' → '.$viaggio['arrivo'], 'nav_active' => 'cerca']) ?>

<?php $this->start('body') ?>

<section class="section">
  <div class="section-inner">

    <!-- breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:20px">
      <a href="<?= $base_path ?>/cerca" style="color:var(--brand)">← Tutti i viaggi</a>
    </div>

    <?php $q = $_GET ?? []; ?>
    <?php if (isset($q['ok'])): ?>
    <div class="alert alert-success">✅ Prenotazione confermata! Buon viaggio.</div>
    <?php elseif (isset($q['nuovo'])): ?>
    <div class="alert alert-success">🎉 Viaggio pubblicato con successo!</div>
    <?php elseif (isset($q['err']) && $q['err'] === 'posti'): ?>
    <div class="alert alert-danger">❌ Posti esauriti. Riprova con un altro viaggio.</div>
    <?php elseif (isset($q['err']) && $q['err'] === 'autista'): ?>
    <div class="alert alert-info">ℹ️ Sei tu l'autista di questo viaggio.</div>
    <?php endif; ?>

    <div class="split-layout">

      <!-- LEFT: dettagli -->
      <div>
        <div class="card">
          <div class="card-body">
            <div style="font-size:11px;font-weight:700;color:var(--accent);letter-spacing:1.5px;text-transform:uppercase">
              <?= date('l d M Y', strtotime($viaggio['data_partenza'])) ?>
            </div>

            <!-- Route -->
            <div style="margin-top:20px;display:flex;align-items:flex-start;gap:16px">
              <div style="display:flex;flex-direction:column;align-items:center;gap:0;padding-top:4px">
                <div style="width:12px;height:12px;border-radius:50%;background:var(--brand);border:2px solid #fff;box-shadow:0 0 0 2px var(--brand)"></div>
                <div style="width:2px;height:48px;background:linear-gradient(var(--brand),var(--accent))"></div>
                <div style="width:12px;height:12px;border-radius:50%;background:var(--accent);border:2px solid #fff;box-shadow:0 0 0 2px var(--accent)"></div>
              </div>
              <div style="flex:1">
                <div style="margin-bottom:24px">
                  <div style="font-size:24px;font-family:var(--serif);font-weight:600"><?= $this->e($viaggio['partenza']) ?></div>
                  <div style="font-size:14px;color:var(--muted)">Ore <?= substr($viaggio['ora_partenza'], 0, 5) ?> · punto di ritrovo da concordare</div>
                </div>
                <div>
                  <div style="font-size:24px;font-family:var(--serif);font-weight:600"><?= $this->e($viaggio['arrivo']) ?></div>
                  <div style="font-size:14px;color:var(--muted)">Arrivo stimato in base al traffico</div>
                </div>
              </div>
            </div>

            <?php if ($viaggio['note']): ?>
            <div class="divider"></div>
            <div>
              <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px">Note del viaggio</div>
              <p style="font-size:14px;color:var(--ink-soft);line-height:1.65"><?= $this->e($viaggio['note']) ?></p>
            </div>
            <?php endif; ?>

            <div class="divider"></div>

            <!-- Preferences -->
            <div style="display:flex;gap:10px;flex-wrap:wrap">
              <span class="chip <?= $viaggio['no_fumo'] ? 'chip-brand' : '' ?>">🚭 <?= $viaggio['no_fumo'] ? 'Non fumatori' : 'Fumatori OK' ?></span>
              <span class="chip <?= $viaggio['no_animali'] ? 'chip-brand' : '' ?>">🐾 <?= $viaggio['no_animali'] ? 'Senza animali' : 'Animali OK' ?></span>
              <?php if ($viaggio['solo_donne']): ?>
              <span class="chip chip-accent">👩 Solo donne</span>
              <?php endif; ?>
              <span class="chip">💺 <?= $viaggio['posti_disponibili'] ?>/<?= $viaggio['posti_totali'] ?> posti liberi</span>
            </div>
          </div>
        </div>

        <!-- Map placeholder -->
        <div class="map-ph mt-20" style="height:180px">
          <svg viewBox="0 0 600 200" preserveAspectRatio="xMidYMid slice">
            <rect width="600" height="200" fill="#e8eee2"/>
            <path d="M-20 60 Q150 70 300 50 T620 80" stroke="#d8d2c2" stroke-width="18" fill="none"/>
            <path d="M-20 140 Q180 120 320 160 T620 130" stroke="#d8d2c2" stroke-width="12" fill="none"/>
            <path d="M80 -10 Q100 80 160 120 T200 210" stroke="#d8d2c2" stroke-width="10" fill="none"/>
            <path d="M420 -10 Q460 80 440 120 T480 210" stroke="#d8d2c2" stroke-width="10" fill="none"/>
            <ellipse cx="150" cy="165" rx="80" ry="30" fill="#cfe0c0"/>
            <ellipse cx="480" cy="30" rx="70" ry="25" fill="#cfe0c0"/>
            <path d="M60 160 Q200 110 300 90 T540 40" stroke="#ee7a3a" stroke-width="5" fill="none" stroke-linecap="round"/>
            <circle cx="60" cy="160" r="8" fill="#1f6b4a" stroke="#fff" stroke-width="2.5"/>
            <circle cx="540" cy="40" r="8" fill="#ee7a3a" stroke="#fff" stroke-width="2.5"/>
          </svg>
          <span class="map-ph-label">📍 <?= $this->e($viaggio['partenza']) ?> → <?= $this->e($viaggio['arrivo']) ?></span>
        </div>

        <!-- Driver -->
        <div class="card mt-20">
          <div class="card-body">
            <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:16px">L'autista</div>
            <div style="display:flex;gap:16px;align-items:flex-start">
              <a href="<?= $base_path ?>/profilo/<?= $viaggio['utente_id'] ?>">
                <span class="avatar avatar-lg"><?= strtoupper(substr($viaggio['nome'], 0, 1)) ?></span>
              </a>
              <div style="flex:1">
                <a href="<?= $base_path ?>/profilo/<?= $viaggio['utente_id'] ?>" style="font-family:var(--serif);font-size:22px;font-weight:600;text-decoration:none;color:var(--ink)">
                  <?= $this->e($viaggio['nome']) ?> <?= $this->e($viaggio['cognome'][0]) ?>.
                </a>
                <div style="display:flex;align-items:center;gap:8px;margin-top:6px;font-size:13px;color:var(--muted)">
                  <span style="color:var(--accent)">★</span>
                  <strong><?= number_format($voto_medio, 1) ?></strong>
                  <?php if($num_recensioni == 1): ?>
                      <span>(<?= $num_recensioni ?> recensione)</span>
                  <?php else: ?>
                      <span>(<?= $num_recensioni ?> recensioni)</span>
                  <?php endif; ?>
                </div>
                <?php if ($viaggio['auto']): ?>
                <div style="font-size:13px;color:var(--muted);margin-top:6px">
                  🚗 <?= $this->e($viaggio['auto']) ?>
                </div>
                <?php endif; ?>
                <?php if ($viaggio['bio']): ?>
                <p style="font-size:14px;color:var(--ink-soft);margin-top:10px;line-height:1.6"><?= $this->e(mb_substr($viaggio['bio'], 0, 160)) ?>...</p>
                <?php endif; ?>
              </div>
            </div>
          </div>
        </div>

        <!-- Passengers -->
        <?php if (!empty($passeggeri)): ?>
        <div class="card mt-20">
          <div class="card-body">
            <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:14px">
              Passeggeri (<?= count($passeggeri) ?>)
            </div>
            <div style="display:flex;gap:10px;flex-wrap:wrap">
              <?php foreach ($passeggeri as $p): ?>
              <div style="display:flex;align-items:center;gap:8px;font-size:13px">
                <span class="avatar avatar-sm"><?= strtoupper(substr($p['nome'], 0, 1)) ?></span>
                <span><?= $this->e($p['nome']) ?></span>
                <span style="color:var(--accent)">★ <?= number_format($p['voto_medio'], 1) ?></span>
              </div>
              <?php endforeach; ?>
            </div>
          </div>
        </div>
        <?php endif; ?>
      </div>

      <!-- RIGHT: booking card -->
      <div class="sticky-sidebar">
        <div class="card">
          <div class="card-body">
            <div style="font-size:36px;font-family:var(--serif);font-weight:600;color:var(--brand)">
              <?= number_format($viaggio['prezzo'], 0) ?>€
              <span style="font-size:16px;color:var(--muted);font-family:var(--sans)">/ persona</span>
            </div>
            <div style="font-size:13px;color:var(--muted);margin-top:4px">
              <?= $viaggio['posti_disponibili'] ?> <?= $viaggio['posti_disponibili'] == 1 ? 'posto disponibile' : 'posti disponibili' ?>
            </div>

            <div class="divider"></div>

            <div style="font-size:13px;display:flex;flex-direction:column;gap:8px;color:var(--ink-soft)">
              <div class="flex-between">
                <span>Partenza</span>
                <strong><?= $this->e($viaggio['partenza']) ?>, <?= substr($viaggio['ora_partenza'], 0, 5) ?></strong>
              </div>
              <div class="flex-between">
                <span>Arrivo</span>
                <strong><?= $this->e($viaggio['arrivo']) ?></strong>
              </div>
              <div class="flex-between">
                <span>Data</span>
                <strong><?= date('d M Y', strtotime($viaggio['data_partenza'])) ?></strong>
              </div>
            </div>

            <div class="divider"></div>

            <?php if ($viaggio['posti_disponibili'] == 0): ?>
              <div class="alert alert-warning" style="margin-bottom:0">Posti esauriti per questo viaggio.</div>

            <?php elseif (!isset($_SESSION['utente_id'])): ?>
              <p style="font-size:13px;color:var(--muted);margin-bottom:16px">Effettua l'accesso per prenotare.</p>
              <a href="<?= $base_path ?>/accedi" class="btn btn-primary btn-full btn-lg">Accedi per prenotare</a>
              <a href="<?= $base_path ?>/registrati" class="btn btn-ghost btn-full mt-8">Registrati gratuitamente</a>

            <?php elseif ($viaggio['autista_id'] == $_SESSION['utente_id']): ?>
              <div class="alert alert-info" style="margin-bottom:0">Sei tu l'autista di questo viaggio.</div>

            <?php elseif ($gia_prenotato): ?>
              <div class="alert alert-success" style="margin-bottom:0">✅ Hai già prenotato questo viaggio.</div>

              <?php elseif ($viaggio['solo_donne'] && ($_SESSION['sesso'] ?? '') === 'M'): ?>
              <div class="alert alert-warning" style="margin-bottom:0">👩 Questo viaggio è riservato alle donne.</div>


              <?php else: ?>
              <form action="<?= $base_path ?>/viaggio/<?= $viaggio['id'] ?>/prenota" method="POST">
                <button type="submit" class="btn btn-accent btn-full btn-lg">Prenota ora — <?= number_format($viaggio['prezzo'], 0) ?>€</button>
              </form>
              <p style="font-size:12px;color:var(--muted);text-align:center;margin-top:10px">Prenotazione gratuita, pagamento alla partenza</p>
            <?php endif; ?>

            <?php if (isset($_SESSION['utente_id']) && $viaggio['autista_id'] != $_SESSION['utente_id']): ?>
            <div class="divider"></div>
            <a href="<?= $base_path ?>/messaggi/<?= $viaggio['utente_id'] ?>" class="btn btn-ghost btn-full">
              💬 Scrivi all'autista
            </a>
            <?php endif; ?>
          </div>
        </div>
      </div>

    </div>
  </div>
</section>

<?php $this->stop() ?>
