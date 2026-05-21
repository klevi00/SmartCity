<?php /** @var array $conversazioni @var array $messaggi @var array|null $altro @var int|null $altro_id */ ?>
<?php $this->layout('layout', ['title' => 'Messaggi', 'nav_active' => 'messaggi']) ?>

<?php $this->start('body') ?>

<div class="chat-layout" style="height:calc(100vh - 68px)">

  <!-- Sidebar conversazioni -->
  <div class="chat-sidebar">
    <div class="chat-sidebar-header">
      <div class="chat-sidebar-title">Messaggi</div>
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
        <div class="msg <?= $is_me ? 'me' : 'them' ?>" data-id="<?= $m['id'] ?>">
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
      <form id="form-messaggio" class="chat-input-bar">
          <input type="text" name="testo" id="input-testo" class="chat-input" placeholder="Scrivi un messaggio..." required autocomplete="off" autofocus>
          <button type="submit" class="btn btn-primary">Invia</button>
      </form>
  </div>

    <script>
        // Variabili passate da PHP
        const BASE_PATH  = '<?= $base_path ?>';
        const ALTRO_ID   = <?= (int) $altro['id'] ?>;
        const MIO_ID     = <?= (int) $_SESSION['utente_id'] ?>;
        const ALTRO_INIT = '<?= strtoupper(substr($this->e($altro['nome']), 0, 1)) ?>';

        // Scroll iniziale in fondo
        const chatEl = document.getElementById('chat-messages');
        chatEl.scrollTop = chatEl.scrollHeight;

        // Aggiunge un bubble alla chat
        function aggiungiMessaggio(msg) {
            const isMe = parseInt(msg.mittente_id) === MIO_ID;

            // Evita duplicati (es. messaggio inviato da me, arriva anche via SSE)
            if (chatEl.querySelector('.msg[data-id="' + msg.id + '"]')) return;

            const avatarHtml = !isMe
                ? `<span class="avatar avatar-xs" style="margin-right:8px;flex-shrink:0">${ALTRO_INIT}</span>`
                : '';

            // Parsing sicuro della data MySQL "YYYY-MM-DD HH:MM:SS"
            const d   = new Date(msg.created_at.replace(' ', 'T'));
            const ora = d.getHours().toString().padStart(2, '0') + ':'
                + d.getMinutes().toString().padStart(2, '0');

            // Escape XSS manuale — non usare innerHTML con testo utente non escaped
            const testoSafe = msg.testo
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;');

            const div = document.createElement('div');
            div.className  = 'msg ' + (isMe ? 'me' : 'them');
            div.dataset.id = msg.id;
            div.innerHTML  = `
      ${avatarHtml}
      <div>
        <div class="msg-bubble">${testoSafe}</div>
        <div class="msg-time">${ora}</div>
      </div>`;

            chatEl.appendChild(div);
            chatEl.scrollTop = chatEl.scrollHeight;
        }

        // Apre la connessione SSE
        const msgs   = chatEl.querySelectorAll('.msg[data-id]');
        let   lastId = msgs.length ? msgs[msgs.length - 1].dataset.id : 0;

        const source = new EventSource(
            BASE_PATH + '/messaggi/' + ALTRO_ID + '/stream?last_id=' + lastId
        );

        source.onmessage = (e) => {
            const msg = JSON.parse(e.data);
            aggiungiMessaggio(msg);
            lastId = msg.id;
        };

        source.onerror = () => {
            console.warn('SSE: connessione persa, il browser riproverà automaticamente.');
        };

        // Invio messaggio senza reload
        document.getElementById('form-messaggio').addEventListener('submit', async (e) => {
            e.preventDefault();

            const input = document.getElementById('input-testo');
            const testo = input.value.trim();
            if (!testo) return;

            // Ottimismo UI: svuota subito il campo
            input.value = '';
            input.focus();

            await fetch(BASE_PATH + '/messaggi/' + ALTRO_ID + '/invia', {
                method:  'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body:    'testo=' + encodeURIComponent(testo)
            });
            // Il messaggio arriverà via SSE entro ~1 secondo
        });
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
