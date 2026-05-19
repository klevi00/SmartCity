<?php /** @var string $base_path @var string $title @var array|null $session_user */ ?>
<!doctype html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= $this->e($title ?? 'Tragitto') ?> — Tragitto</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="stylesheet" href="<?= $base_path ?>/public/style.css">
</head>
<body>

<nav class="nav">
    <a href="<?= $base_path ?>/" class="nav-logo">
        BlablaGian
    </a>

  <ul class="nav-links">
    <li><a href="<?= $base_path ?>/" class="<?= ($nav_active ?? '') === 'home' ? 'active' : '' ?>">Home</a></li>
    <li><a href="<?= $base_path ?>/cerca" class="<?= ($nav_active ?? '') === 'cerca' ? 'active' : '' ?>">Cerca un viaggio</a></li>
    <?php if (isset($_SESSION['utente_id'])): ?>
    <li><a href="<?= $base_path ?>/pubblica" class="<?= ($nav_active ?? '') === 'pubblica' ? 'active' : '' ?>">Pubblica</a></li>
    <li><a href="<?= $base_path ?>/miei-viaggi" class="<?= ($nav_active ?? '') === 'miei' ? 'active' : '' ?>">I miei viaggi</a></li>
    <li><a href="<?= $base_path ?>/messaggi" class="<?= ($nav_active ?? '') === 'messaggi' ? 'active' : '' ?>">Messaggi</a></li>
    <?php endif; ?>
  </ul>

  <div class="nav-spacer"></div>

  <?php if (isset($_SESSION['utente_id'])): ?>
  <div class="nav-user">
    <a href="<?= $base_path ?>/profilo/<?=$_SESSION['utente_id']?>"><span class="avatar avatar-sm"><?= strtoupper(substr($_SESSION['utente_nome'] ?? 'U', 0, 1)) ?></span></a>
    <span style="font-size:13px;font-weight:600"><?= $this->e($_SESSION['utente_nome'] ?? '') ?></span>
    <a href="<?= $base_path ?>/esci" class="btn btn-ghost btn-sm">Esci</a>
  </div>
  <?php else: ?>
  <div class="nav-actions">
    <a href="<?= $base_path ?>/accedi" class="btn btn-ghost btn-sm">Accedi</a>
    <a href="<?= $base_path ?>/registrati" class="btn btn-primary btn-sm">Registrati</a>
  </div>
  <?php endif; ?>
</nav>

<?= $this->section('body') ?>

<footer>
  <strong style="font-family:var(--serif);color:var(--brand)">BlablaGian</strong> &nbsp;-
  Carpooling sostenibile in Italia &nbsp;
</footer>

</body>
</html>
