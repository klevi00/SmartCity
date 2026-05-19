<?php /** @var array $utente @var array $errori */ ?>
<?php $this->layout('layout', ['title' => 'Modifica profilo']) ?>

<?php $this->start('body') ?>

<section class="section" style="min-height:calc(100vh - 200px);display:flex;align-items:center">
  <div style="width:100%;max-width:480px;margin:0 auto">

    <div style="text-align:center;margin-bottom:32px">
      <a href="<?= $base_path ?>/" style="display:inline-flex;align-items:center;gap:8px;font-family:var(--serif);font-size:24px;font-weight:600;color:var(--brand);text-decoration:none">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
          <rect x="2" y="2" width="28" height="28" rx="14" fill="#1f6b4a"/>
          <path d="M9 12 L23 12 M16 12 L16 23" stroke="#fff" stroke-width="3" stroke-linecap="round"/>
          <circle cx="23" cy="20" r="2.5" fill="#ee7a3a"/>
        </svg>
        tragitto
      </a>
      <h1 style="font-family:var(--serif);font-size:30px;font-weight:600;margin-top:20px;letter-spacing:-0.5px">Modifica il tuo profilo</h1>
      <p style="color:var(--muted);font-size:15px;margin-top:8px">Le informazioni che aggiungi sono visibili agli altri utenti.</p>
    </div>

      <?php if (isset($_SESSION['flash'])): ?>
      <div class="form-error" style="background:var(--cream);border:1px solid var(--danger);border-radius:var(--r-md);padding:14px 16px;margin-bottom:20px;font-size:14px">
          ⚠️ <?= $this->e($_SESSION['flash']) ?>
      </div>
      <?php unset($_SESSION['flash']); ?>
      <?php endif; ?>

    <div class="card">
      <div class="card-body">
        <form action="<?= $base_path ?>/profilo/<?= $utente['id'] ?>/modifica" method="POST">

          <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
            <div class="form-group">
              <label class="form-label">Nome *</label>
              <input type="text" name="nome" class="form-input"
                     value="<?= $this->e($utente['nome'] ?? '') ?>" placeholder="Mario" required>
              <?php if (isset($errori['nome'])): ?><div class="form-error"><?= $this->e($errori['nome']) ?></div><?php endif; ?>
            </div>
            <div class="form-group">
              <label class="form-label">Cognome *</label>
              <input type="text" name="cognome" class="form-input"
                     value="<?= $this->e($utente['cognome'] ?? '') ?>" placeholder="Rossi" required>
              <?php if (isset($errori['cognome'])): ?><div class="form-error"><?= $this->e($errori['cognome']) ?></div><?php endif; ?>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">Telefono</label>
            <input type="tel" name="telefono" class="form-input"
                   value="<?= $this->e($utente['telefono'] ?? '') ?>" placeholder="333 1234567">
            <div class="form-hint">Opzionale. Utile per essere contattato dagli altri utenti.</div>
          </div>

          <div class="form-group">
            <label class="form-label">Bio</label>
            <textarea name="bio" class="form-input" rows="4"
                      placeholder="Raccontati agli altri utenti…"
                      style="resize:vertical"><?= $this->e($utente['bio'] ?? '') ?></textarea>
          </div>

          <div class="form-group">
            <label class="form-label">Auto</label>
            <input type="text" name="auto" class="form-input"
                   value="<?= $this->e($utente['auto'] ?? '') ?>" placeholder="Fiat 500 Bianca">
          </div>

          <div class="form-group">
            <label class="form-label">Numero patente</label>
            <input type="text" name="num_patente" class="form-input"
                   value="<?= $this->e($utente['num_patente'] ?? '') ?>" placeholder="U1234F567B" maxlength="10">
            <?php if (isset($errori['num_patente'])): ?><div class="form-error"><?= $this->e($errori['num_patente']) ?></div><?php endif; ?>
          </div>

          <button type="submit" class="btn btn-primary btn-full btn-lg">Salva modifiche</button>

        </form>
      </div>
    </div>

    <p style="text-align:center;font-size:14px;color:var(--muted);margin-top:20px">
      <a href="<?= $base_path ?>/profilo/<?= $utente['id'] ?>" style="color:var(--brand);font-weight:600">← Torna al profilo</a>
    </p>

  </div>
</section>

<?php $this->stop() ?>
