"use client";
import Button from "@mui/material/Button";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Stack from "@mui/material/Stack";
import HeadsetMicIcon from "@mui/icons-material/HeadsetMic";

const files = [
  { name: "Drive Leitura Biométrica | FS-80 'preta'", file: "/Leitor Biometrico FS-80.zip" },
  { name: "Drive Leitura Biométrica | 4000B 'prata'", file: "/Leitor Biometrico 4000B.zip" },
  { name: "Download Firefox", file: "/Firefox47.exe" },
  { name: "Download Java 8u421 - 32bits", file: "/java-8u421-windows-i586.exe" },
  { name: "Download Java 8u231 - 32bits 'antigo'", file: "/java-8u231-windows-i586.exe" },
  { name: "Script de Configuração Firefox", file: "/config.ps1" },
];

export default function Home() {
  return (
    <Box
      minHeight="100vh"
      width="100vw"
      display="flex"
      justifyContent="center"
      alignItems="center"
      sx={{
        backgroundImage: 'url(/unimed.jpg)',
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        backgroundRepeat: 'no-repeat',
        p: 2,
        position: "relative",
        overflow: "hidden",
      }}
    >
      {/* Formas geométricas decorativas */}
      <Box sx={{ position: 'absolute', zIndex: 0, inset: 0, pointerEvents: 'none' }}>
        {/* Círculo verde claro no canto superior esquerdo */}
        <Box sx={{ position: 'absolute', top: -60, left: -60, width: 180, height: 180, bgcolor: '#b2dfdb', borderRadius: '50%', opacity: 0.13 }} />
        {/* Quadrado azul claro no canto inferior direito */}
        <Box sx={{ position: 'absolute', bottom: -40, right: -40, width: 120, height: 120, bgcolor: '#e3f2fd', borderRadius: 4, opacity: 0.13 }} />
        {/* Semicírculo amarelo claro no topo direito */}
        <Box sx={{ position: 'absolute', top: 30, right: -60, width: 120, height: 60, bgcolor: '#fffde7', borderTopLeftRadius: 120, borderTopRightRadius: 120, borderBottomLeftRadius: 0, borderBottomRightRadius: 0, opacity: 0.10 }} />
        {/* Linha diagonal cinza claro */}
        <Box sx={{ position: 'absolute', top: '60%', left: -80, width: 300, height: 12, bgcolor: '#e0e0e0', transform: 'rotate(-20deg)', borderRadius: 6, opacity: 0.08 }} />
        {/* Círculo branco translúcido no centro esquerdo */}
        <Box sx={{ position: 'absolute', top: '40%', left: -70, width: 100, height: 100, bgcolor: '#fff', borderRadius: '50%', opacity: 0.07 }} />
        {/* Pequeno círculo verde escuro no canto inferior esquerdo */}
        <Box sx={{ position: 'absolute', bottom: 30, left: 20, width: 40, height: 40, bgcolor: '#80cbc4', borderRadius: '50%', opacity: 0.10 }} />
      </Box>
      {/* Bloco centralizado */}
      <Box
        display="flex"
        flexDirection="column"
        alignItems="center"
        justifyContent="center"
        sx={{
          width: '100%',
          maxWidth: 480,
          zIndex: 1,
          background: 'rgba(255,255,255,0.6)',
          borderRadius: 6,
          border: '1px solid rgba(50,150,100,0.2)',
          boxShadow: '0 1px 24px 0 rgba(0,0,0,0.10)',
          px: { xs: 2, sm: 4 },
          py: { xs: 3, sm: 5 },
        }}
      >
        {/* Ícone centralizado */}
        <Box
          sx={{
            background: "#fff",
            borderRadius: "50%",
            width: 80,
            height: 80,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            boxShadow: 3,
            mb: 2,
          }}
        >
          <HeadsetMicIcon sx={{ fontSize: 48, color: "#00995D" }} />
        </Box>
        <Typography variant="h5" color="rgba(50,150,100,0.8)" fontWeight={600} textAlign="center" mb={4} mt={2} shadow={3}>
          Suporte Técnico | Unimed Curitiba
        </Typography>
        {/* Botões centralizados */}
        <Stack
          spacing={2}
          width="100%"
          alignItems="center"
          mb={4}
        >
          {files.map((item, idx) => {
            const isExternal = !!item.href;
            const link = item.file || item.href;
            return (
              <Button
                key={link}
                variant="outlined"
                href={link}
                {...(isExternal
                  ? { target: "_blank", rel: "noopener noreferrer" }
                  : { download: true })}
                size="large"
                sx={{
                  width: "100%",
                  color: "rgba(50,150,100,0.6)",
                  borderColor: "rgba(50,150,100,0.3)",
                  borderWidth: 1,
                  fontWeight: 500,
                  fontFamily: "Arial, sans-serif",
                  fontSize: "1.1rem",
                  borderRadius: 2,
                  textTransform: "none",
                  background: "rgba(255,255,255,0.10)",
                  boxShadow: '0 1px 8px 0 rgba(56,142,60,0.04)',
                  transition: 'all 0.2s',
                  '&:hover': {
                    background: "rgba(50,150,100,0.9)",
                    color: "#fff",
                    borderColor: "rgba(50,150,100,0.3)",
                  },
                }}
              >
                {item.name}
              </Button>
            );
          })}
        </Stack>
      </Box>
      {/* Rodapé fixo */}
      <Box
        position="fixed"
        bottom={0}
        left={0}
        width="100vw"
        py={1}
        sx={{ background: 'transparent', zIndex: 2 }}
      >
        <Typography variant="body2" color="#fff" align="center">
          
        </Typography>
      </Box>
    </Box>
  );
}
