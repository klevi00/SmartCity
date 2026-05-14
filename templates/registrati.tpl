<?php /** @var array $errori @var array $dati */ ?>
<?php $this->layout('layout', ['title' => 'Registrati']) ?>

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
      <h1 style="font-family:var(--serif);font-size:30px;font-weight:600;margin-top:20px;letter-spacing:-0.5px">Crea il tuo account</h1>
      <p style="color:var(--muted);font-size:15px;margin-top:8px">Gratis. Unisciti alla community di Tragitto.</p>
    </div>

    <div class="card">
      <div class="card-body">
        <form action="<?= $base_path ?>/registrati" method="POST">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
            <div class="form-group">
              <label class="form-label">Nome *</label>
              <input type="text" name="nome" class="form-input"
                     value="<?= $this->e($dati['nome'] ?? '') ?>" placeholder="Mario" required>
              <?php if (isset($errori['nome'])): ?><div class="form-error"><?= $this->e($errori['nome']) ?></div><?php endif; ?>
            </div>
            <div class="form-group">
              <label class="form-label">Cognome *</label>
              <input type="text" name="cognome" class="form-input"
                     value="<?= $this->e($dati['cognome'] ?? '') ?>" placeholder="Rossi" required>
              <?php if (isset($errori['cognome'])): ?><div class="form-error"><?= $this->e($errori['cognome']) ?></div><?php endif; ?>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label">Email *</label>
            <input type="email" name="email" class="form-input"
                   value="<?= $this->e($dati['email'] ?? '') ?>" placeholder="mario.rossi@email.com" required>
            <?php if (isset($errori['email'])): ?><div class="form-error"><?= $this->e($errori['email']) ?></div><?php endif; ?>
          </div>

          <div class="form-group">
            <label class="form-label">Telefono *</label>
            <input type="tel" name="telefono" class="form-input"
                   value="<?= $this->e($dati['telefono'] ?? '') ?>" placeholder="333 1234567">
            <div class="form-hint">Opzionale. Utile per essere contattato dagli autisti.</div>
          </div>

          <div class="form-group">
            <label class="form-label">Password *</label>
            <input type="password" name="password" class="form-input" placeholder="Almeno 8 caratteri" required>
            <?php if (isset($errori['password'])): ?><div class="form-error"><?= $this->e($errori['password']) ?></div><?php endif; ?>
          </div>

          <div class="form-group">
            <label class="form-label">Conferma password *</label>
            <input type="password" name="password2" class="form-input" placeholder="Ripeti la password" required>
            <?php if (isset($errori['password2'])): ?><div class="form-error"><?= $this->e($errori['password2']) ?></div><?php endif; ?>
          </div>

            <div class="form-group">
                <label class="form-label">Bio</label>
                <input type="text" name="bio" class="form-input" placeholder="Inserisci la bio">
            </div>

            <div class="form-group">
                <label class="form-label">Auto</label>
                <input type="text" name="auto" class="form-input" placeholder="Fiat 500 Bianca">
            </div>

            <div class="form-group">
                <label class="form-label">Numero patente</label>
                <input type="text" name="num_patente" class="form-input" placeholder="U1234F567B">
            </div>

          <button type="submit" class="btn btn-primary btn-full btn-lg">Crea account</button>

          <p style="font-size:12px;color:var(--muted);text-align:center;margin-top:14px;line-height:1.6">
            Registrandoti accetti i termini di servizio e la privacy policy di Tragitto.
          </p>
        </form>
      </div>
    </div>

    <p style="text-align:center;font-size:14px;color:var(--muted);margin-top:20px">
      Hai già un account?
      <a href="<?= $base_path ?>/accedi" style="color:var(--brand);font-weight:600">Accedi</a>
    </p>

  </div>
</section>

<?php $this->stop() ?>
