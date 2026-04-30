<?php /** @var string|null $errore */ ?>
<?php $this->layout('layout', ['title' => 'Accedi']) ?>

<?php $this->start('body') ?>

<section class="section" style="min-height:calc(100vh - 200px);display:flex;align-items:center">
  <div style="width:100%;max-width:440px;margin:0 auto">

    <div style="text-align:center;margin-bottom:32px">
      <a href="<?= $base_path ?>/" style="display:inline-flex;align-items:center;gap:8px;font-family:var(--serif);font-size:24px;font-weight:600;color:var(--brand);text-decoration:none">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none">
          <rect x="2" y="2" width="28" height="28" rx="14" fill="#1f6b4a"/>
          <path d="M9 12 L23 12 M16 12 L16 23" stroke="#fff" stroke-width="3" stroke-linecap="round"/>
          <circle cx="23" cy="20" r="2.5" fill="#ee7a3a"/>
        </svg>
        tragitto
      </a>
      <h1 style="font-family:var(--serif);font-size:30px;font-weight:600;margin-top:20px;letter-spacing:-0.5px">Bentornato/a</h1>
      <p style="color:var(--muted);font-size:15px;margin-top:8px">Accedi al tuo account per continuare</p>
    </div>

    <?php if ($errore): ?>
    <div class="alert alert-danger"><?= $this->e($errore) ?></div>
    <?php endif; ?>

    <div class="card">
      <div class="card-body">
        <form action="<?= $base_path ?>/accedi" method="POST">
          <div class="form-group">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-input" placeholder="la-tua@email.com" required autofocus>
          </div>
          <div class="form-group">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-input" placeholder="••••••••" required>
          </div>
          <button type="submit" class="btn btn-primary btn-full btn-lg" style="margin-top:8px">Accedi</button>
        </form>
      </div>
    </div>

    <p style="text-align:center;font-size:14px;color:var(--muted);margin-top:20px">
      Non hai ancora un account?
      <a href="<?= $base_path ?>/registrati" style="color:var(--brand);font-weight:600">Registrati gratuitamente</a>
    </p>

  </div>
</section>

<?php $this->stop() ?>
