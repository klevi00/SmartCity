
{*<?php /** @var array $utente @var array $recensioni @var array $viaggi */ ?>*}
{*<?php $this->layout('layout', ['title' => $utente['nome'].' '.$utente['cognome']]) ?>*}

{*<?php $this->start('body') ?>*}

{*<section class="section">*}
{*  <div class="section-inner">*}
{*    <div class="split-layout">*}

{*      <!-- LEFT -->*}
{*      <div>*}
{*        <!-- Profile header -->*}
{*        <div class="profile-header">*}
{*          <span class="avatar avatar-xl"><?= strtoupper(substr($utente['nome'], 0, 1)) ?></span>*}
{*          <h1 class="profile-name"><?= $this->e($utente['nome']) ?> <?= $this->e($utente['cognome'][0]) ?>.</h1>*}
{*          <div class="profile-rating">*}
{*            <span style="color:var(--accent);font-size:16px">★</span>*}
{*            <strong style="font-size:16px"><?= number_format($utente['voto_medio'], 1) ?></strong>*}
{*            <span>(<?= $utente['num_recensioni'] ?> recensioni)</span>*}
{*            <?php if ($utente['num_recensioni'] > 50): ?>*}
{*            <span class="chip chip-success">✓ Super autista</span>*}
{*            <?php endif; ?>*}
{*          </div>*}
{*          <?php if ($utente['bio']): ?>*}
{*          <p class="profile-bio"><?= $this->e($utente['bio']) ?></p>*}
{*          <?php endif; ?>*}

{*          <?php if ($utente['auto_marca']): ?>*}
{*          <div class="divider"></div>*}
{*          <div style="display:flex;gap:20px;flex-wrap:wrap;font-size:14px">*}
{*            <div>*}
{*              <div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:4px">Auto</div>*}
{*              <strong><?= $this->e($utente['auto_marca']) ?> <?= $this->e($utente['auto_modello']) ?></strong>*}
{*              <span style="color:var(--muted)"> · <?= $this->e($utente['auto_colore']) ?></span>*}
{*            </div>*}
{*            <?php if ($utente['telefono']): ?>*}
{*            <div>*}
{*              <div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:4px">Contatto</div>*}
{*              <strong><?= $this->e($utente['telefono']) ?></strong>*}
{*            </div>*}
{*            <?php endif; ?>*}
{*            <div>*}
{*              <div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:4px">Membro dal</div>*}
{*              <strong><?= date('M Y', strtotime($utente['created_at'])) ?></strong>*}
{*            </div>*}
{*          </div>*}
{*          <?php endif; ?>*}

{*          <?php if (isset($_SESSION['utente_id']) && $_SESSION['utente_id'] != $utente['id']): ?>*}
{*          <div class="divider"></div>*}
{*          <a href="<?= $base_path ?>/messaggi/<?= $utente['id'] ?>" class="btn btn-ghost">💬 Invia un messaggio</a>*}
{*          <?php endif; ?>*}
{*        </div>*}

{*        <!-- Reviews -->*}
{*        <?php if (!empty($recensioni)): ?>*}
{*        <div class="card mt-20">*}
{*          <div class="card-body">*}
{*            <h2 style="font-family:var(--serif);font-size:22px;font-weight:600;margin-bottom:20px">*}
{*              Recensioni (<?= count($recensioni) ?>)*}
{*            </h2>*}
{*            <?php foreach ($recensioni as $r): ?>*}
{*            <div class="review-card">*}
{*              <div class="review-author">*}
{*                <span class="avatar avatar-sm"><?= strtoupper(substr($r['autore_nome'], 0, 1)) ?></span>*}
{*                <div>*}
{*                  <div style="font-size:14px;font-weight:600"><?= $this->e($r['autore_nome']) ?> <?= $this->e($r['autore_cognome'][0]) ?>.</div>*}
{*                  <div style="font-size:11px;color:var(--muted)"><?= date('d M Y', strtotime($r['created_at'])) ?></div>*}
{*                </div>*}
{*                <div style="margin-left:auto;display:flex;gap:2px">*}
{*                  <?php for ($i = 1; $i <= 5; $i++): ?>*}
{*                  <svg width="13" height="13" viewBox="0 0 24 24" style="fill:<?= $i <= $r['voto'] ? '#ee7a3a' : '#d8d2c4' ?>">*}
{*                    <path d="M12 2 L14.9 8.6 L22 9.3 L16.5 14 L18.2 21 L12 17.3 L5.8 21 L7.5 14 L2 9.3 L9.1 8.6 Z"/>*}
{*                  </svg>*}
{*                  <?php endfor; ?>*}
{*                </div>*}
{*              </div>*}
{*              <?php if ($r['commento']): ?>*}
{*              <p class="review-text">"<?= $this->e($r['commento']) ?>"</p>*}
{*              <?php endif; ?>*}
{*            </div>*}
{*            <?php endforeach; ?>*}
{*          </div>*}
{*        </div>*}
{*        <?php endif; ?>*}
{*      </div>*}

{*      <!-- RIGHT: viaggi recenti -->*}
{*      <div>*}
{*        <?php if (!empty($viaggi)): ?>*}
{*        <div class="card sticky-sidebar">*}
{*          <div class="card-body">*}
{*            <h3 style="font-family:var(--serif);font-size:20px;font-weight:600;margin-bottom:16px">Viaggi pubblicati</h3>*}
{*            <div class="stack">*}
{*              <?php foreach ($viaggi as $v): ?>*}
{*              <?php if ($v['stato'] !== 'attivo') continue; ?>*}
{*              <a href="<?= $base_path ?>/viaggio/<?= $v['id'] ?>" style="text-decoration:none;color:inherit;padding:14px;background:var(--cream);border-radius:var(--r-md);display:block;border:1px solid var(--line)">*}
{*                <div style="font-family:var(--serif);font-size:16px;font-weight:600">*}
{*                  <?= $this->e($v['partenza']) ?> → <?= $this->e($v['arrivo']) ?>*}
{*                </div>*}
{*                <div style="font-size:13px;color:var(--muted);margin-top:4px">*}
{*                  <?= date('d M', strtotime($v['data_partenza'])) ?> · <?= substr($v['ora_partenza'], 0, 5) ?>*}
{*                  · <strong style="color:var(--brand)"><?= number_format($v['prezzo'], 0) ?>€</strong>*}
{*                </div>*}
{*              </a>*}
{*              <?php endforeach; ?>*}
{*            </div>*}
{*          </div>*}
{*        </div>*}
{*        <?php endif; ?>*}
{*      </div>*}

{*    </div>*}
{*  </div>*}
{*</section>*}

{*<?php $this->stop() ?>*}