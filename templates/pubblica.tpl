<?php /** @var array $errori @var array $dati */ ?>
<?php $this->layout('layout', ['title' => 'Pubblica un viaggio', 'nav_active' => 'pubblica']) ?>

<?php $this->start('body') ?>

<section class="section">
  <div class="section-inner" style="max-width:820px">

    <div style="font-size:11px;font-weight:700;color:var(--accent);letter-spacing:1.5px;text-transform:uppercase">PUBBLICA UN VIAGGIO</div>
    <h1 style="font-family:var(--serif);font-size:40px;font-weight:600;letter-spacing:-1px;margin-top:6px">Dove vai oggi?</h1>
    <p style="font-size:15px;color:var(--muted);margin-top:6px">Compila i dettagli del viaggio. Ci vogliono circa 2 minuti.</p>

    <?php if (!empty($errori)): ?>
    <div class="alert alert-danger mt-20">
      <div>
        <strong>Correggi i seguenti errori:</strong>
        <ul style="margin:8px 0 0 16px">
          <?php foreach ($errori as $e): ?>
          <li><?= $this->e($e) ?></li>
          <?php endforeach; ?>
        </ul>
      </div>
    </div>
    <?php endif; ?>

    <form action="<?= $base_path ?>/pubblica" method="POST" class="mt-32">

      <!-- TRATTA -->
      <div class="card mb-24">
        <div class="card-body">
          <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:4px">Tratta</h2>
          <p style="font-size:13px;color:var(--muted);margin-bottom:24px">Da dove parti e dove arrivi?</p>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Città di partenza *</label>
              <input type="text" name="partenza" class="form-input <?= isset($errori['partenza']) ? 'border-danger' : '' ?>"
                     placeholder="es. Milano" value="<?= $this->e($dati['partenza'] ?? '') ?>" required>
              <?php if (isset($errori['partenza'])): ?><div class="form-error"><?= $this->e($errori['partenza']) ?></div><?php endif; ?>
            </div>
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Città di arrivo *</label>
              <input type="text" name="arrivo" class="form-input <?= isset($errori['arrivo']) ? 'border-danger' : '' ?>"
                     placeholder="es. Bologna" value="<?= $this->e($dati['arrivo'] ?? '') ?>" required>
              <?php if (isset($errori['arrivo'])): ?><div class="form-error"><?= $this->e($errori['arrivo']) ?></div><?php endif; ?>
            </div>
          </div>
        </div>
      </div>

      <!-- DATA E ORARIO -->
      <div class="card mb-24">
        <div class="card-body">
          <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:4px">Data e orario</h2>
          <p style="font-size:13px;color:var(--muted);margin-bottom:24px">Quando parte il viaggio?</p>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Data di partenza *</label>
              <input type="date" name="data_partenza" class="form-input"
                     min="<?= date('Y-m-d') ?>" value="<?= $this->e($dati['data_partenza'] ?? date('Y-m-d')) ?>" required>
              <?php if (isset($errori['data_partenza'])): ?><div class="form-error"><?= $this->e($errori['data_partenza']) ?></div><?php endif; ?>
            </div>
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Orario di partenza *</label>
              <input type="time" name="ora_partenza" class="form-input"
                     value="<?= $this->e($dati['ora_partenza'] ?? '08:00') ?>" required>
              <?php if (isset($errori['ora_partenza'])): ?><div class="form-error"><?= $this->e($errori['ora_partenza']) ?></div><?php endif; ?>
            </div>
          </div>
        </div>
      </div>

      <!-- POSTI E PREZZO -->
      <div class="card mb-24">
        <div class="card-body">
          <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:4px">Posti e prezzo</h2>
          <p style="font-size:13px;color:var(--muted);margin-bottom:24px">Quanti passeggeri e quanto costa?</p>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Posti disponibili *</label>
              <select name="posti_totali" class="form-input">
                <?php for ($i = 1; $i <= 4; $i++): ?>
                <option value="<?= $i ?>" <?= ($dati['posti_totali'] ?? '3') == $i ? 'selected' : '' ?>><?= $i ?> <?= $i == 1 ? 'posto' : 'posti' ?></option>
                <?php endfor; ?>
              </select>
              <?php if (isset($errori['posti_totali'])): ?><div class="form-error"><?= $this->e($errori['posti_totali']) ?></div><?php endif; ?>
            </div>
            <div class="form-group" style="margin-bottom:0">
              <label class="form-label">Prezzo per persona (€) *</label>
              <input type="number" name="prezzo" class="form-input" min="1" max="500" step="0.5"
                     placeholder="es. 18" value="<?= $this->e($dati['prezzo'] ?? '') ?>" required>
              <?php if (isset($errori['prezzo'])): ?><div class="form-error"><?= $this->e($errori['prezzo']) ?></div><?php endif; ?>
              <div class="form-hint">Consigliamo un prezzo equo che copra le spese di carburante.</div>
            </div>
          </div>
        </div>
      </div>

      <!-- PREFERENZE -->
      <div class="card mb-24">
        <div class="card-body">
          <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:4px">Preferenze</h2>
          <p style="font-size:13px;color:var(--muted);margin-bottom:20px">Definisci le regole del tuo viaggio</p>
          <div class="checkbox-group">
            <label class="checkbox-item">
              <input type="checkbox" name="no_fumo" <?= isset($dati['no_fumo']) ? 'checked' : '' ?>>
              🚭 Viaggio per non fumatori
            </label>
            <label class="checkbox-item">
              <input type="checkbox" name="no_animali" <?= isset($dati['no_animali']) ? 'checked' : '' ?>>
              🐾 Senza animali
            </label>
            <label class="checkbox-item">
              <input type="checkbox" name="solo_donne" <?= isset($dati['solo_donne']) ? 'checked' : '' ?>>
              👩 Solo donne
            </label>
          </div>
        </div>
      </div>

      <!-- NOTE -->
      <div class="card mb-32">
        <div class="card-body">
          <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:4px">Note aggiuntive</h2>
          <p style="font-size:13px;color:var(--muted);margin-bottom:16px">Punto di ritrovo, bagagli, musica... qualsiasi info utile</p>
          <textarea name="note" class="form-textarea" rows="4" placeholder="Es. Partenza da Lampugnano P1. Bagaglio medio in bagagliaio."><?= $this->e($dati['note'] ?? '') ?></textarea>
        </div>
      </div>

      <div class="flex-between">
        <a href="<?= $base_path ?>/" class="btn btn-ghost">Annulla</a>
        <button type="submit" class="btn btn-primary btn-lg">Pubblica viaggio →</button>
      </div>

      <p style="font-size:12px;color:var(--muted);text-align:center;margin-top:16px">Le tue informazioni sono salvate automaticamente</p>
    </form>
  </div>
</section>

<?php $this->stop() ?>
