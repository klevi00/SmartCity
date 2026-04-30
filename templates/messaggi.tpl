<?php /** @var array $conversazioni @var array $messaggi @var array|null $altro @var int|null $altro_id */ ?>
<?php $this->layout('layout', ['title' => 'Messaggi', 'nav_active' => 'messaggi']) ?>

<?php $this->start('body') ?>

<div class="chat-layout" style="height:calc(100vh - 68px)">

  <!-- Sidebar conversazioni -->
  <div class="chat-sidebar">
    <div class="chat-sidebar-header">
      <div class="chat-sidebar-title">Messaggi</div>
      <div class="chat-search mt-12">
        <input type="text" class="form-input" placeholder="🔍 Cerca conversazioni" style="border-radius:var(--r-pill)">
      </div>
    </div>
    <div class="chat-tabs">
      <div class="chat-tab active">Tutti</div>
      <div class="chat-tab">Non letti</div>
    </div>

    <?php if (empty($conversazioni)): ?>
    <div style="padding:40px 20px;text-align:center;color:var(--muted)">
      <div style="font-size:32px;margin-bottom:12px">💬</div>
      <div style="font-size:14px">Nessuna conversazione ancora</div>
    </div>
    <?php else: ?>
    <?php foreach ($conversazioni as $c): ?>
    <a href="<?= $base_path ?>/messaggi/<?= $c['id'] ?>"
       class="chat-thread <?= $c['id'] == $altro_id ? 'active' : '' ?>">
      <div style="position:relative;flex-shrink:0">
        <span class="avatar avatar-md"><?= strtoupper(substr($c['nome'], 0, 1)) ?></span>
        <?php if ($c['non_letti'] > 0): ?>
        <div class="unread-badge" style="position:absolute;top:-2px;right:-2px"><?= $c['non_letti'] ?></div>
        <?php endif; ?>
      </div>
      <div style="flex:1;min-width:0">
        <div class="chat-thread-meta">
          <div class="chat-thread-name"><?= $this->e($c['nome']) ?> <?= $this->e($c['cognome'][0]) ?>.</div>
          <div class="chat-thread-time"><?= date('H:i', strtotime($c['ultimo_at'])) ?></div>
        </div>
        <div class="chat-thread-last"><?= $this->e(mb_substr($c['ultimo_messaggio'], 0, 50)) ?>...</div>
      </div>
    </a>
    <?php endforeach; ?>
    <?php endif; ?>
  </div>

  <!-- Main chat -->
  <?php if ($altro): ?>
  <div class="chat-main">
    <!-- Header -->
    <div class="chat-header">
      <span class="avatar avatar-md"><?= strtoupper(substr($altro['nome'], 0, 1)) ?></span>
      <div style="flex:1">
        <div style="font-size:15px;font-weight:700"><?= $this->e($altro['nome']) ?> <?= $this->e($altro['cognome']) ?></div>
        <div style="font-size:12px;color:var(--muted)">
          <a href="<?= $base_path ?>/profilo/<?= $altro['id'] ?>" style="color:var(--brand)">Vedi profilo</a>
        </div>
      </div>
    </div>

    <!-- Messaggi -->
    <div class="chat-messages" id="chat-messages">
      <?php if (empty($messaggi)): ?>
      <div style="text-align:center;padding:40px;color:var(--muted);font-size:14px">
        Nessun messaggio ancora. Scrivi il primo!
      </div>
      <?php else: ?>
      <div style="text-align:center;font-size:11px;color:var(--muted);margin:16px 0;text-transform:uppercase;letter-spacing:1px">— Conversazione —</div>
      <?php foreach ($messaggi as $m): ?>
      <?php $is_me = $m['mittente_id'] == $_SESSION['utente_id']; ?>
      <div class="msg <?= $is_me ? 'me' : 'them' ?>">
        <?php if (!$is_me): ?>
        <span class="avatar avatar-xs" style="margin-right:8px;flex-shrink:0"><?= strtoupper(substr($altro['nome'], 0, 1)) ?></span>
        <?php endif; ?>
        <div>
          <div class="msg-bubble"><?= $this->e($m['testo']) ?></div>
          <div class="msg-time"><?= date('H:i', strtotime($m['created_at'])) ?></div>
        </div>
      </div>
      <?php endforeach; ?>
      <?php endif; ?>
    </div>

    <!-- Input -->
    <form action="<?= $base_path ?>/messaggi/<?= $altro['id'] ?>/invia" method="POST" class="chat-input-bar">
      <input type="text" name="testo" class="chat-input" placeholder="Scrivi un messaggio..." required autocomplete="off" autofocus>
      <button type="submit" class="btn btn-primary">Invia</button>
    </form>
  </div>

  <script>
    const el = document.getElementById('chat-messages');
    if (el) el.scrollTop = el.scrollHeight;
  </script>

  <?php else: ?>
  <div class="chat-main" style="align-items:center;justify-content:center">
    <div class="empty-state">
      <div class="empty-state-icon">💬</div>
      <div class="empty-state-title">Seleziona una conversazione</div>
      <p class="empty-state-sub">Oppure prenota un viaggio e scrivi all'autista.</p>
    </div>
  </div>
  <?php endif; ?>

</div>

<?php $this->stop() ?>
